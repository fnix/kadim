# frozen_string_literal: true

module Kadim
  module Generators
    class ScaffoldControllerGenerator < Rails::Generators::NamedBase
      def initialize(args = [], local_options = {}, config = {})
        @initial_args = args
        @initial_local_options = local_options
        super
      end

      def scaffold_controller
        model_path = name.underscore
        unless Kadim.app_model_paths.include?(model_path)
          puts "Are you sure \"#{name}\" is a model?"
          return
        end

        @initial_args += Kadim.scaffold_attributes(model_path.camelize.constantize) if @initial_args.one?

        Rails::Generators.namespace = Kadim
        generator = Rails::Generators::ScaffoldControllerGenerator.new(
          @initial_args, @initial_local_options, behavior: behavior, destination_root: destination_root
        )

        # jbuilder 2.9.1 controller template uses a method removed from Rails6
        # https://github.com/rails/jbuilder/issues/470
        source_path_idx = generator.class.source_paths.index { |source_path| source_path.include?("jbuilder") }
        generator.class.source_paths[source_path_idx] = generator.class.source_root if source_path_idx

        generator.invoke_all
      end
    end
  end
end
