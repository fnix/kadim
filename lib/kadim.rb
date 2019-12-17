# frozen_string_literal: true

require "kadim/engine"
require "kadim/template/memory_resolver"

module Kadim
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
    Erb::Generators::ScaffoldGenerator.source_paths.prepend(
      File.expand_path("generators/kadim/scaffold_controller/templates", __dir__)
    )

    generator = Rails::Generators::ScaffoldControllerGenerator.new(args, options, config)
    source_path_idx = generator.class.source_paths.index { |source_path| source_path.include?("jbuilder") }
    generator.class.source_paths[source_path_idx] = generator.class.source_root if source_path_idx
    generator.invoke_all
  ensure
    Rails::Generators.namespace = current_namespace
  end

  def self.scaffold_attributes(model_klass)
    model_klass.columns
               .reject { |column| %w[id created_at updated_at].include?(column.name) }
               .sort_by(&:name)
               .map { |column| [column.name, column.type] }
               .to_h
               .map { |k, v| "#{k}:#{v}" }
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
