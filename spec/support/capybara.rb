# frozen_string_literal: true

Capybara.configure do |config|
  config.save_path = Rails.root.join("../tmp")
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end
