# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kadim/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kadim"
  spec.version     = Kadim::VERSION
  spec.authors     = ["Kadu Diógenes"]
  spec.email       = ["kadu@fnix.com.br"]
  spec.homepage    = "https://github.com/fnix/kadim"
  spec.summary     = "Yet another Rails admin? No, only a kadim."
  spec.description = "Don't let admins pull out your hair!"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "activestorage-resumable", "~> 1.0.0"
  spec.add_dependency "rails", "~> 6.0.0"

  spec.add_development_dependency "capybara", "~> 3.29.0"
  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "puma", "~> 4.2.0"
  spec.add_development_dependency "rspec-rails", "~> 3.8.0"
  spec.add_development_dependency "rubocop", "~> 0.72.0"
  spec.add_development_dependency "rubocop-performance", "~> 1.5.0"
  spec.add_development_dependency "rubocop-rails", "~> 2.3.0"
  spec.add_development_dependency "rubocop-rspec", "~> 1.36.0"
  spec.add_development_dependency "selenium-webdriver", "~> 3.142.0"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "webdrivers", "~> 4.1.0"
end
