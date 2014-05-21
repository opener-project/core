# coding: utf-8
require File.expand_path('../lib/opener/core/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "opener-core"
  spec.version       = Opener::Core::VERSION
  spec.authors       = ["development@olery.com"]
  spec.summary       = %q{Gem that contains some low lever generic functions for all OpeNER components.}
  spec.description   = spec.summary
  spec.homepage      = "http://opener-project.github.com"
  spec.license       = "Apachev2"

  spec.files = Dir.glob([
    'lib/**/*',
    '*.gemspec',
    'README.md'
  ]).select { |file| File.file?(file) }

  spec.executables = Dir.glob('bin/*').map { |file| File.basename(file) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
