# frozen_string_literal: true

module Kadim
  module Host
    class ScaffoldControllerGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def scaffold_controller
        model_path = name.underscore
        unless Kadim.app_model_paths.include?(model_path)
          puts "Are you sure \"#{name}\" is a model?"
          return
        end


        Rails::Generators.namespace = Kadim
        generator = Rails::Generators::ScaffoldControllerGenerator.new(
          [model_path, *Kadim.scaffold_attributes(model_path.camelize.constantize)],
          ["--no-jbuilder", "--template-engine=erb"],
          behavior: behavior,
          destination_root: destination_root
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
