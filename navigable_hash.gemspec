# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "navigable_hash"
  spec.version       = "1.1.0"
  spec.authors       = ["Jason Waldrip", "Kevin Wanek"]
  spec.email         = ["jason@waldrip.net", "k@dmcy.us"]
  spec.description   = %q{Allows a hash to be navigated with dot notation or indifferent access.}
  spec.summary       = %q{Allows a hash to be navigated with dot notation or indifferent access.}
  spec.homepage      = "http://github.com/jwaldrip/navigable_hash"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "10.1.0"
  spec.add_development_dependency "rspec", '2.14'
  spec.add_development_dependency "pry", '0.9.12.2'
  spec.add_development_dependency "coveralls", "0.6.7"
  spec.add_development_dependency "guard", "1.8.2"
  spec.add_development_dependency "guard-rspec", "3.0.2"
  spec.add_development_dependency "guard-bundler", "1.0.0"
  spec.add_development_dependency "simplecov-multi", "0.0.1"

end
