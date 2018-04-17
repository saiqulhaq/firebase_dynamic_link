require 'dry-configurable'
require 'faraday'
require 'firebase_dynamic_link/client'
require 'firebase_dynamic_link/version'

module FirebaseDynamicLink
  extend Dry::Configurable

  class InvalidConfig < StandardError; end
  class ConnectionError < StandardError; end

  # You can change it to
  # FirebaseDynamicLink.adapter = :patron
  # FirebaseDynamicLink.adapter = :httpclient
  # FirebaseDynamicLink.adapter = :net_http_persistent
  #
  # And get the value by
  # FirebaseDynamicLink.adapter
  setting :adapter, Faraday.default_adapter

  setting :api_key

  # Timeout default setting is 3 seconds
  setting :timeout, 3

  # Open timeout default setting is 3 seconds
  setting :open_timeout, 3

  # This domain will be used if dynamic_link_domain setting is nil
  # it raises error if both of settings are nil
  setting :default do
    # Firebase dynamic link domain
    setting(:dynamic_link_domain)
    setting :suffix do
      setting(:option, 'UNGUESSABLE') { |value|
        %w(SHORT UNGUESSABLE).include?(value) ? value : raise(FirebaseDynamicLink::InvalidConfig, 'default suffix option config is not valie')
      }
    end
  end
end
