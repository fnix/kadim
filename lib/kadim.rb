# frozen_string_literal: true

require "kadim/engine"
require "kadim/template/memory_resolver"

module Kadim
  # @overload upload_type
  #   @return [Symbol] current upload type used to scaffold file input fields
  # @overload upload_type=(value)
  #   You can use the following symbols to set the upload type:
  #   * :local     - Uses ActiveStorage {https://guides.rubyonrails.org/active_storage_overview.html#disk-service Disk Service}
  #   * :direct    - Uses ActiveStorage {https://guides.rubyonrails.org/active_storage_overview.html#direct-uploads Direct Upload}
  #   * :resumable - Uses {https://rubygems.org/gems/activestorage-resumable activestorage-resumable gem} to implement {https://cloud.google.com/storage/docs/performing-resumable-uploads Resumable Uploads} (supports only GCS)
  #   @param value [Symbol]
  #   @return [Symbol]
  mattr_accessor :upload_type

  # @overload layout
  #   @return [Symbol, nil] current layout or nil for the default Rails layout for scaffold_controller
  # @overload layout=(value)
  #   The following layouts are available:
  #   * nil - No layout, will use Rails generators template.
  #   * :bulma - A layout using the {https://bulma.io bulma} CSS framework.
  mattr_accessor :layout

  def self.init
    @@upload_type ||= if [:amazon, :google, :microsoft].include?(Rails.configuration.active_storage.service)
      :direct
    else
      :local
    end
  end

  def self.configure
    yield self
  end

  def self.app_model_paths
    return [] unless db_connection?

    Dir[Rails.root.join("app", "models", "**", "*.rb")]
      .reject { |model_path| model_path.include?("/concerns/") || model_path.include?("application_record") }
      .map    { |model_path| model_path.remove(%r{.*/app/models/}, ".rb") }
      .select { |model_path| model_path.camelize.constantize.try(:table_exists?) }
      .sort
  end

  def self.bootstrap_controllers
    return unless db_connection?

    cleanup
    load_app_kadim_consts
    scaffold_controllers
  end

  def self.scaffold_controller(args, options, config)
    current_namespace = Rails::Generators.namespace
    Rails::Generators.namespace = Kadim

    require "rails/generators/erb/scaffold/scaffold_generator"
    templates_path = if Kadim.layout == :bulma
      "generators/kadim/scaffold_controller/templates/bulma"
    else
      "generators/kadim/scaffold_controller/templates"
    end
    Erb::Generators::ScaffoldGenerator.source_paths.prepend(File.expand_path(templates_path, __dir__))

    generator = Rails::Generators::ScaffoldControllerGenerator.new(args, options, config)
    source_path_idx = generator.class.source_paths.index { |source_path| source_path.include?("jbuilder") }
    generator.class.source_paths[source_path_idx] = generator.class.source_root if source_path_idx
    generator.invoke_all
  ensure
    Rails::Generators.namespace = current_namespace
  end

  def self.scaffold_attributes(model_klass)
    database_attributes(model_klass) + attachment_attributes(model_klass)
  end

  class << self
    private
      def cleanup
        cleanup_tmp_files
        cleanup_kadim_consts
      end

      def cleanup_tmp_files
        FileUtils.remove_dir(Rails.root.join("tmp", "kadim"), true)
      end

      def cleanup_kadim_consts
        app_model_paths.each do |model_path|
          controller_klass_name = "#{model_path.pluralize}_controller".camelize
          Kadim.send(:remove_const, controller_klass_name) if Kadim.const_defined?(controller_klass_name, false)
        end
      end

      def load_app_kadim_consts
        Dir[Rails.root.join("app", "controllers", "kadim", "**", "*_controller.rb")].each { |path| load path }
        Dir[Rails.root.join("app", "helpers", "kadim", "**", "*_helper.rb")].each { |path| load path }
      end

      def scaffold_controllers
        Rails.application.load_generators
        require "rails/generators/rails/scaffold_controller/scaffold_controller_generator"

        app_model_paths.each do |model_name|
          next if Kadim.const_defined?("#{model_name.pluralize}_controller".camelize, false)
          model_klass = model_name.camelize.constantize
          return unless model_klass.table_exists?

          args = [model_name, *scaffold_attributes(model_klass)]
          options = ["--force", "--quiet", "--no-test-framework", "--no-helper", "--template-engine=erb"]
          config = { destination_root: Rails.root.join("tmp", "kadim") }

          scaffold_controller(args, options, config)
        end
        load_kadim_controllers
        load_kadim_views
      end

      def database_attributes(model_klass)
        model_klass.columns
                   .reject { |column| %w[id created_at updated_at].include?(column.name) }
                   .sort_by(&:name)
                   .map { |column| [column.name, column.type] }
                   .to_h
                   .map { |k, v| "#{k}:#{v}" }
      end

      def attachment_attributes(model_klass)
        model_klass.attachment_reflections
                   .values
                   .map do |reflection|
                     attribute_type = if reflection.is_a?(ActiveStorage::Reflection::HasOneAttachedReflection)
                       "attachment"
                     else
                       "attachments"
                     end
                     "#{reflection.name}:#{attribute_type}"
                   end
      end

      def load_kadim_controllers
        Dir[Rails.root.join("tmp", "kadim", "app", "controllers", "**", "*_controller.rb")].each do |path|
          retries ||= 0
          load path
        rescue LoadError
          retry if (retries += 1) < 3
          raise "Ops, failed to load kadim controllers, please restart your application!"
        end
      end

      def load_kadim_views
        Kadim::MemoryResolver.instance.clear
        Dir[Rails.root.join("tmp", "kadim", "app", "views", "**", "*.html.erb")].each do |file_path|
          view_match = %r{.*/app/views/(.*)(\.html\.erb)}.match(file_path)
          view_path = view_match[1]
          Kadim::MemoryResolver.instance.add(IO.read(file_path), view_path)
        end
      end

      def db_connection?
        ActiveRecord::Base.connection
        ActiveRecord::Base.connected?
      rescue ActiveRecord::AdapterNotFound, ActiveRecord::AdapterNotSpecified, ActiveRecord::NoDatabaseError
        false
      end
  end
end
