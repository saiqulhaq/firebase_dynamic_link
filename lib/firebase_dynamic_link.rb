# frozen_string_literal: true

require "dry-configurable"
require "faraday"
require "firebase_dynamic_link/client"
require "firebase_dynamic_link/link_renderer"
require "firebase_dynamic_link/version"

module FirebaseDynamicLink
  extend Dry::Configurable

  class InvalidConfig < StandardError; end
  class ConnectionError < StandardError; end
  class QuotaExceeded < StandardError; end

  # @!group Configuration
  # @!method adapter
  #   @!scope class
  # @!method adapter=(adapter_key)
  #   @!scope class
  #   @param adapter_key [Symbol]
  #   @example
  #     FirebaseDynamicLink.adapter = :patron
  #     FirebaseDynamicLink.adapter = :httpclient
  #     FirebaseDynamicLink.adapter = :net_http_persistent
  #   @see https://github.com/lostisland/faraday/tree/master/test/adapters
  # @since 0.1.0
  setting :adapter, Faraday.default_adapter

  # @!method api_key
  #   @!scope class
  # @!method api_key=(key)
  #   @!scope class
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
