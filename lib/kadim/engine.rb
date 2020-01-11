# frozen_string_literal: true

require "active_link_to"
require "activestorage/resumable"
require "bulma-rails"
require "font-awesome-sass"

module Kadim
  class Engine < ::Rails::Engine
    isolate_namespace Kadim

    initializer "kadim.assets" do
      config.assets.precompile += %w[
        kadim/application.css
        kadim/application.js
        kadim/bulma/application.css
        kadim/bulma/application.js
      ]
    end

    config.to_prepare do
      Kadim.init
      Kadim.bootstrap_controllers
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
