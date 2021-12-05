# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'firebase_dynamic_link/version'

Gem::Specification.new do |spec|
  spec.name          = 'firebase_dynamic_link'
  spec.version       = FirebaseDynamicLink::VERSION
  spec.authors       = ['M Saiqul Haq']
  spec.email         = ['saiqulhaq@gmail.com']

  spec.summary       = 'Ruby client for Firebase Dynamic Link service'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/saiqulhaq/firebase_dynamic_link'
  spec.license       = 'MIT'
  spec.metadata['yard.run'] = 'yri'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'case_transform2', '>= 1.0', '< 2.0'
  spec.add_runtime_dependency 'dry-configurable', '>= 0.6', '< 1.0'
  spec.add_runtime_dependency 'faraday', '>= 0.16', '< 3.0'
  spec.add_runtime_dependency 'faraday-net_http', '>= 1.0', '< 2.0'

  spec.add_development_dependency 'appraisal', '~> 2.4.1'
  spec.add_development_dependency 'bootsnap', '~> 1.9.3'
  spec.add_development_dependency 'bundle-audit', '~> 0.1.0'
  spec.add_development_dependency 'bundler', '>= 2.0'
  spec.add_development_dependency 'dotenv', '~> 2.2', '>= 2.2.2'
  spec.add_development_dependency 'pry', '~> 0.14.1'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.10.0'
  spec.add_development_dependency 'rubocop', '~> 1.22'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.5.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.1'
  spec.add_development_dependency 'vcr', '~> 4.0', '>= 4.0.0'
end
