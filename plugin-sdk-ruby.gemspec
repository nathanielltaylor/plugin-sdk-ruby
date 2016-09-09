# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "plugin-sdk-ruby"
  spec.version       = Komand::VERSION
  spec.authors       = ["Komand Security"]
  spec.email         = ["sean@komand.com"]

  spec.summary       = "Plugin SDK for the Komand Platform"
  spec.homepage      = "https://github.com/komand/plugin-sdk-ruby"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "json-schema", "~>2.6.0"
  spec.add_dependency "faraday", "~>0.9.0"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
