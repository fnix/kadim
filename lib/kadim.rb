# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/rails/scaffold_controller/scaffold_controller_generator'

require 'kadim/engine'
require 'kadim/template/memory_resolver'

module Kadim
  def self.app_model_names
    Dir[Rails.root.join('app', 'models', '**', '*.rb')]
      .reject { |model_path| model_path.include?('concerns') || model_path.include?('application_record') }
      .map { |model_path| model_path.remove(%r{.*/app/models/}, '.rb') }
  end

  def self.bootstrap_controllers!
    current_namespace = Rails::Generators.namespace
    cleanup_tmp_files!
    load_app_controllers!

    Rails::Generators.namespace = Kadim
    app_model_names.each do |model_name|
      controller_name = "#{model_name.pluralize}_controller".camelize
      next if Kadim.const_defined?(controller_name, false)

      scaffold_controller!(model_name)
    end
    load_kadim_controllers!
    load_kadim_views!
  ensure
    Rails::Generators.namespace = current_namespace
  end

  class << self
    private

      def cleanup_tmp_files!
        FileUtils.remove_dir(Rails.root.join('tmp', 'kadim'), true)
      end

      def load_app_controllers!
        Dir[Rails.root.join('app', 'controllers', 'kadim', '**', '*_controller.rb')].each { |path| require path }
      end

      def scaffold_controller!(model_name)
        model_klass = model_name.camelize.constantize
        scaffold_attributes = model_klass.columns
                                         .map { |c| [c.name, c.type] }
                                         .to_h
                                         .reject { |k, _v| %w[id created_at updated_at].include?(k) }
                                         .map { |k, v| "#{k}:#{v}" }
        generator = Rails::Generators::ScaffoldControllerGenerator.new(
          [model_name, *scaffold_attributes],
          ['--force', '--quiet', '--no-orm', '--no-test-framework', '--no-helper'],
          destination_root: Rails.root.join('tmp', 'kadim')
        )
        generator.invoke_all
      end

      def load_kadim_controllers!
        Dir[Rails.root.join('tmp', 'kadim', 'app', 'controllers', '**', '*_controller.rb')].each { |path| require path }
      end

      def load_kadim_views!
        Dir[Rails.root.join('tmp', 'kadim', 'app', 'views', '**', '*.html.erb')].each do |file_path|
          view_match = %r{.*/app/views/(.*)(\.html\.erb)}.match(file_path)
          view_path = view_match[1]
          Kadim::MemoryResolver.instance.add(IO.read(file_path), view_path)
        end
      end
  end
end
