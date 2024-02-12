$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "kadim/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "kadim"
  spec.version     = Kadim::VERSION
  spec.authors     = ["Kadu Diógenes"]
  spec.email       = ["kadu@fnix.com.br"]
  spec.homepage    = "https://github.com/fnix/kadim"
  spec.summary     = "Scaffold based admin for Rails."
  spec.description = "Scaffold based admin for Rails."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.0", ">= 5.2.0"

  spec.add_development_dependency "sqlite3", "~> 1.6.0", "< 1.7"
end
