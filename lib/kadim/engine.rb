# frozen_string_literal: true

require "active_link_to"
require "activestorage/resumable"
require "bulma-rails"

module Kadim
  class Engine < ::Rails::Engine
    isolate_namespace Kadim

    initializer "kadim.assets" do
      config.assets.precompile += %w[
        kadim/application.css
        kadim/application.js
        kadim/application_bulma.css
        kadim/application_bulma.js
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
