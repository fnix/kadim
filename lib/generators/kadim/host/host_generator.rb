# frozen_string_literal: true

module Kadim
  class HostGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    BASE_DIRS = [
      "app/assets/javascripts/kadim",
      "app/assets/stylesheets/kadim",
      "app/controllers/kadim",
      "app/helpers/kadim",
      "app/views/kadim",
      "app/views/layouts/kadim"
    ]

    def copy_base_files
      self.class.source_root File.expand_path("../../../..", __dir__)
      BASE_DIRS.each { |dirname| directory dirname }
    end
  end
end
