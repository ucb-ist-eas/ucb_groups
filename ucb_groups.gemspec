# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ucb_groups/version'

Gem::Specification.new do |spec|
  spec.name          = "ucb_groups"
  spec.version       = UcbGroups::VERSION
  spec.authors       = ["sahglie"]
  spec.email         = ["sahglie@gmail.com"]
  spec.description   = %q{Finds users that belong to a given ucb group}
  spec.summary       = %q{Finds users that belong to a given ucb group}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.7"
  spec.add_development_dependency "rest-client"
  spec.add_development_dependency "json"

  spec.add_runtime_dependency "ucb_ldap", "2.0.0.pre5"
  spec.add_runtime_dependency "net-ldap", "0.2.2"
end
