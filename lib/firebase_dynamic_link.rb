# frozen_string_literal: true

require "dry-configurable"
require "faraday"
if Faraday::VERSION.to_f >= 2.0
  require "faraday/net_http"
end
require "firebase_dynamic_link/client"
require "firebase_dynamic_link/link_renderer"
require "firebase_dynamic_link/version"

module FirebaseDynamicLink
  extend Dry::Configurable

  USE_FARADAY_2 = Faraday::VERSION.to_i == 2

  # called when invalid configuration given
  class InvalidConfig < StandardError; end

  # called when HTTP request failed
  class ConnectionError < StandardError; end

  # called when Firebase says that no more quota
  class QuotaExceeded < StandardError; end

  # @!group Configuration
  # @!method adapter
  #   @!scope class
  #   Selected Faraday HTTP adapter
  # @!method adapter=(adapter_key)
  #   @!scope class
  #   Set Faraday HTTP adapter
  #   @param adapter_key [Symbol]
  #   @example
  #     FirebaseDynamicLink.adapter = :patron
  #     FirebaseDynamicLink.adapter = :httpclient
  #     FirebaseDynamicLink.adapter = :net_http_persistent
  #   @see https://github.com/lostisland/faraday/tree/master/test/adapters
  # @since 0.1.0
  if FirebaseDynamicLink::USE_FARADAY_2 && Faraday.default_adapter == :test
    Faraday.default_adapter = :net_http # default adapter included in this gem
  end
  setting :adapter, Faraday.default_adapter 

  # @!method api_key
  #   @!scope class
  #   Given api key
  # @!method api_key=(key)
  #   @!scope class
  #   Set api key
  #   @param key [String]
  # @since 0.1.0
  setting :api_key

  # @!method timout
  #   Timeout default setting is 3 seconds
  #   @!scope class
  # @!method timout=(seconds)
  #   @!scope class
  #   @param seconds [Integer]
  # @since 0.1.0
  # @!scope class
  setting :timeout, 3

  # @!method open_timout
  #   @!scope class
  #   Open timeout default setting is 3 seconds
  # @!method open_timout=(seconds)
  #   @!scope class
  #   @param seconds [Integer]
  # @since 0.1.0
  # @!scope class
  setting :open_timeout, 3

  # @!method dynamic_link_domain
  #   @!scope class
  #   Firebase dynamic link domain
  # @!method dynamic_link_domain=(domain)
  #   @!scope class
  #   @param domain [String]
  # @since 1.0.0
  # @!scope class
  setting(:dynamic_link_domain)

  # @!method suffix_option
  #   @!scope class
  #   Firebase suffix option setting, default is UNGUESSABLE
  # @!method suffix_option=(suffix)
  #   @!scope class
  #   @raise [FirebaseDynamicLink::InvalidConfig] if value is not one of SHORT and UNGUESSABLE
  #   @param suffix [String]
  # @since 1.0.0
  # @!scope class
  setting(:suffix_option, "UNGUESSABLE") do |value|
    %w[SHORT UNGUESSABLE].include?(value) ? value : raise(FirebaseDynamicLink::InvalidConfig, "default suffix option config is not valid")
  end
  # @!endgroup
end
