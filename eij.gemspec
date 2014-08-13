# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eij/version'

Gem::Specification.new do |spec|
  spec.name          = "eij"
  spec.version       = Eij::VERSION
  spec.authors       = ["Kevin Vollmer"]
  spec.email         = ["works.kvollmer@gmail.com"]
  spec.summary       = %q{Kanjidamage wrapper}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["eij"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "data"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
