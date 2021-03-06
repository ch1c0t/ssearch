# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ssearch/version'

Gem::Specification.new do |spec|
  spec.name          = "ssearch"
  spec.version       = Ssearch::VERSION
  spec.authors       = ["Anatoly Chernow"]
  spec.email         = ["ch1c0t@yahoo.com"]
  spec.description   = %q{Simple search}
  spec.summary       = %q{Simple search}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "foreman"
  spec.add_development_dependency 'awesome_print'

  spec.add_runtime_dependency 'redis'
  spec.add_runtime_dependency 'msgpack'
  spec.add_runtime_dependency 'daybreak'
end
