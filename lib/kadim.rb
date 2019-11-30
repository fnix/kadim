# frozen_string_literal: true

require "kadim/engine"
require "kadim/template/memory_resolver"

module Kadim
  def self.app_model_paths
    Dir[Rails.root.join("app", "models", "**", "*.rb")]
      .reject { |model_path| model_path.include?("/concerns/") || model_path.include?("application_record") }
      .map    { |model_path| model_path.remove(%r{.*/app/models/}, ".rb") }
      .select { |model_path| model_path.camelize.constantize.try(:table_exists?) }
      .sort
  end

  def self.bootstrap_controllers
    cleanup
    scaffold_controllers
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
        controller_filenames.each do |controller_filename|
          next if File.exist?(Rails.root.join("app", "controllers", "kadim", "#{controller_filename}.rb"))

          controller_klass = controller_filename.camelize
          Kadim.send(:remove_const, controller_klass) if Kadim.const_defined?(controller_klass, false)
        end
      end

      def controller_filenames
        app_model_paths.map { |model_name| "#{model_name.pluralize}_controller" }
      end

      def scaffold_controllers
        Rails.application.load_generators
        require "rails/generators/rails/scaffold_controller/scaffold_controller_generator"

        current_namespace = Rails::Generators.namespace
        Rails::Generators.namespace = Kadim
        app_model_paths.each { |model_name| scaffold_controller(model_name) }
        load_kadim_controllers
        load_kadim_views
      ensure
        Rails::Generators.namespace = current_namespace
      end

      def scaffold_controller(model_name)
        model_klass = model_name.camelize.constantize
        return unless model_klass.table_exists?

        generator = Rails::Generators::ScaffoldControllerGenerator.new(
          [model_name, *scaffold_attributes(model_klass)],
          ["--force", "--quiet", "--no-test-framework", "--no-helper"],
          destination_root: Rails.root.join("tmp", "kadim")
        )
        source_path_idx = generator.class.source_paths.index { |source_path| source_path.include?("jbuilder") }
        generator.class.source_paths[source_path_idx] = generator.class.source_root if source_path_idx
        generator.invoke_all
      end

      def load_kadim_controllers
        Dir[Rails.root.join("tmp", "kadim", "app", "controllers", "**", "*_controller.rb")].each { |path| load path }
      end

      def load_kadim_views
        Kadim::MemoryResolver.instance.clear
        Dir[Rails.root.join("tmp", "kadim", "app", "views", "**", "*.html.erb")].each do |file_path|
          view_match = %r{.*/app/views/(.*)(\.html\.erb)}.match(file_path)
          view_path = view_match[1]
          Kadim::MemoryResolver.instance.add(IO.read(file_path), view_path)
        end
      end
  end
end
