# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uwn/api/version'

Gem::Specification.new do |spec|
  spec.name          = "uwn-api"
  spec.version       = Uwn::Api::VERSION
  spec.authors       = ["Dennis Blommesteijn"]
  spec.email         = ["dennis@blommesteijn.com"]
  spec.description   = %q{UWN/MENTA: Towards a Universal Multilingual Wordnet API; (Ruby on Rails) gem wrapper for JRuby.}
  spec.summary       = %q{UWN/MENTA: Towards a Universal Multilingual Wordnet API; (Ruby on Rails) gem wrapper for JRuby.}
  spec.homepage      = ""
  spec.license       = "LGPL-3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  # dependencies
  spec.add_dependency 'nokogiri', "~> 1.5.0"
  spec.add_dependency 'json', "~> 1.6.1"

  
  spec.add_development_dependency "test-unit", "~> 2.0.0"
end
