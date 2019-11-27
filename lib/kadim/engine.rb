# frozen_string_literal: true

module Kadim
  class Engine < ::Rails::Engine
    isolate_namespace Kadim

    initializer "kadim.assets" do
      config.assets.precompile += %w[
        kadim/application.css
        kadim/application.js
      ]
    end

    config.to_prepare do
      Kadim.bootstrap_controllers
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
