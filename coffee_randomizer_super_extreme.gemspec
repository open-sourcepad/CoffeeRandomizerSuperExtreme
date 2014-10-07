# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coffee_randomizer_super_extreme/version'

Gem::Specification.new do |spec|
  spec.name          = "coffee_randomizer_super_extreme"
  spec.version       = CoffeeRandomizerSuperExtreme::VERSION
  spec.authors       = ["Maria Regina Cu Famador", "John Norman Capule"]
  spec.email         = ["mariaf@sourcepad.com", "normanc@sourcepad.com"]
  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7.3"
  spec.add_development_dependency "rspec", "~> 3.0.0"
  spec.add_development_dependency "pry", "~> 0.10.0"
  spec.add_development_dependency "logger", "~> 1.2.8"
  spec.add_development_dependency "rake"
end
