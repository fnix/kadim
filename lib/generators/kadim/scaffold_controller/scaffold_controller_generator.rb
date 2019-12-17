# frozen_string_literal: true

module Kadim
  module Generators
    class ScaffoldControllerGenerator < Rails::Generators::NamedBase
      def initialize(args = [], local_options = {}, config = {})
        @initial_args = args
        @initial_options = local_options
        @initial_config = config
        super
      end

      def scaffold_controller
        model_path = name.underscore
        unless Kadim.app_model_paths.include?(model_path)
          puts "Are you sure \"#{name}\" is a model?"
          return
        end

        @initial_args += Kadim.scaffold_attributes(model_path.camelize.constantize) if @initial_args.one?

        Kadim.scaffold_controller(@initial_args, @initial_options, @initial_config)
      end
    end
  end
end
