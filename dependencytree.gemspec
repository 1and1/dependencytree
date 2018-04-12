# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dependencytree/version"

Gem::Specification.new do |spec|
  spec.name          = "dependencytree"
  spec.version       = Dependencytree::VERSION
  spec.authors       = ["Stephan Fuhrmann"]
  spec.email         = ["stephan.fuhrmann@1und1.de"]

  spec.summary       = %q{Calculate class dependencies and output to JSON.}
  spec.description   = %q{Analyse Ruby source code, analyse class dependencies and output everything as a JSON.}
  spec.homepage      = "http://www.1und1.de"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.executables << 'dependencytree'
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_dependency "parser", "~> 2.5.0.5"
  spec.add_dependency "ast", "~> 2.4.0"
end
