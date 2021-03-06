require File.expand_path('../lib/opener/core/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'opener-core'
  spec.version       = Opener::Core::VERSION
  spec.authors       = ['development@olery.com']
  spec.summary       = 'Gem that contains some low level generic functions for all OpeNER components.'
  spec.description   = spec.summary
  spec.homepage      = 'http://opener-project.github.com'
  spec.license       = 'Apache 2.0'

  spec.files = Dir.glob([
    'lib/**/*',
    '*.gemspec',
    'README.md',
    'LICENSE.txt'
  ]).select { |file| File.file?(file) }

  spec.executables = Dir.glob('bin/*').map { |file| File.basename(file) }

  spec.add_dependency 'slop', '~> 3.0'
  spec.add_dependency 'httpclient'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
