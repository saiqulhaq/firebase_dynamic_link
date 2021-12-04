# frozen_string_literal: true

require "bundler/setup"
require "bootsnap"

enable_coverage = ENV.fetch("COVERAGE", 0).to_s == '1'

if RUBY_VERSION == 3 && Faraday::VERSION.to_f < 1.2
  exit(false)
end

Bootsnap.setup(
  cache_dir:            "tmp/cache",          # Path to your cache
  development_mode:     true,                 # Current working environment, e.g. RACK_ENV, RAILS_ENV, etc
  load_path_cache:      true,                 # Optimize the LOAD_PATH with a cache
  compile_cache_iseq:   !enable_coverage, # Compile Ruby code into ISeq cache, breaks coverage reporting.
  compile_cache_yaml:   true # Compile YAML into a cache
)

require "dotenv/load"

if enable_coverage
  require "simplecov"
  SimpleCov.start
end

require "firebase_dynamic_link"
require "vcr"

begin
  require "pry"
rescue LoadError
end

require "dry/configurable/test_interface"

begin
  module FirebaseDynamicLink
    enable_test_interface
  end

rescue LoadError
  module FirebaseDynamicLink
    extend Dry::Configurable::TestInterface
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :faraday
end
