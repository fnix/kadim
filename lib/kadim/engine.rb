# frozen_string_literal: true

module Kadim
  class Engine < ::Rails::Engine
    isolate_namespace Kadim

    initializer 'kadim.bootstrap' do
      if Rails.configuration.cache_classes
        ::Kadim.bootstrap_controllers!
      else
        ActiveSupport::Reloader.to_prepare do
          ::Kadim.bootstrap_controllers!
        end
      end
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
