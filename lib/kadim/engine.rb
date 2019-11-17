# frozen_string_literal: true

module Kadim
  class Engine < ::Rails::Engine
    isolate_namespace Kadim

    config.to_prepare do
      Kadim.bootstrap_controllers
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
