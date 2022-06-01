# typed: true
# frozen_string_literal: true

require "dry-configurable"
require "dry/configurable/version"
require "faraday"
require "faraday/net_http" if Faraday::VERSION.to_f >= 2.0
require "firebase_dynamic_link/client"
require "firebase_dynamic_link/link_renderer"
require "firebase_dynamic_link/version"

module FirebaseDynamicLink
  extend Dry::Configurable

  USE_FARADAY_2 = Faraday::VERSION.to_i == 2
  USE_DRY_CONFIGURABLE_0_13 = Dry::Configurable::VERSION.to_f >= 0.13

  # called when invalid configuration given
  class InvalidConfig < StandardError; end

  # called when HTTP request failed
  class ConnectionError < StandardError; end

  # called when Firebase says that no more quota
  class QuotaExceeded < StandardError; end

  if FirebaseDynamicLink::USE_FARADAY_2 && Faraday.default_adapter == :test
    Faraday.default_adapter = :net_http # default adapter included in this gem
  end

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
  if USE_DRY_CONFIGURABLE_0_13
    setting :adapter, default: Faraday.default_adapter
  else
    setting :adapter, Faraday.default_adapter
  end

  # @!method api_key
  #   @!scope class
  #   Given api key
  # @!method api_key=(key)
  #   @!scope class
  #   Set api key
  #   @param key [String]
  # @since 0.1.0
  setting :api_key

  # @!method timeout
  #   Timeout default setting is 3 seconds
  #   @!scope class
  # @!method timeout=(seconds)
  #   @!scope class
  #   @param seconds [Integer]
  # @since 0.1.0
  # @!scope class
  if USE_DRY_CONFIGURABLE_0_13
    setting :timeout, default: 3
  else
    setting :timeout, 3
  end

  # @!method open_timeout
  #   @!scope class
  #   Open timeout default setting is 3 seconds
  # @!method open_timeout=(seconds)
  #   @!scope class
  #   @param seconds [Integer]
  # @since 0.1.0
  # @!scope class
  if USE_DRY_CONFIGURABLE_0_13
    setting :open_timeout, default: 3
  else
    setting :open_timeout, 3
  end

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
  if USE_DRY_CONFIGURABLE_0_13
    setting(:suffix_option, default: "UNGUESSABLE", constructor: lambda { |value|
      if %w[SHORT
        UNGUESSABLE].include?(value)
        value
      else
        raise(FirebaseDynamicLink::InvalidConfig,
          "default suffix option config is not valid")
      end
    })
  else
    setting(:suffix_option, "UNGUESSABLE") do |value|
      if %w[SHORT
        UNGUESSABLE].include?(value)
        value
      else
        raise(FirebaseDynamicLink::InvalidConfig,
          "default suffix option config is not valid")
      end
    end

  end
  # @!endgroup
end
