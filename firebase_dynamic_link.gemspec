
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'firebase_dynamic_link/version'

Gem::Specification.new do |spec|
  spec.name          = 'firebase_dynamic_link'
  spec.version       = FirebaseDynamicLink::VERSION
  spec.authors       = ['M Saiqul Haq']
  spec.email         = ['saiqulhaq@gmail.com']

  spec.summary       = 'Ruby client for Firebase Dynamic Link service'
  spec.description   = 'Ruby client API for Firebase Dynamic Link'
  spec.homepage      = 'https://github.com/saiqulhaq/firebase_dynamic_link'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-core', '~> 0.4.5'
  spec.add_dependency 'dry-configurable', '~> 0.7.0'
  spec.add_dependency 'faraday', '~> 0.14.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.11.3'
end
