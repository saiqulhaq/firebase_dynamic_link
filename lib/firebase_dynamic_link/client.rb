# frozen_string_literal: true

require "firebase_dynamic_link/connection"
require "firebase_dynamic_link/link_renderer"

module FirebaseDynamicLink
  class Client
    attr_accessor :dynamic_link_domain
    extend Forwardable

    def initialize
      @link_renderer = FirebaseDynamicLink::LinkRenderer.new
      @connection = FirebaseDynamicLink::Connection.new(end_point)
    end

    # @param link [String] required
    # @param options [Hash]
    #   * :timeout optional, default is FirebaseDynamicLink.config.timout
    #   * :open_timeout [Integer] optional, default is FirebaseDynamicLink.config.open_timout
    #   * :suffix_option [String] optional, default is FirebaseDynamicLink.config.suffix_option
    #   * :dynamic_link_domain [String] optional, default is FirebaseDynamicLink.config.dynamic_link_domain
    # @return [Hash{Symbol=>String}]
    # @see FirebaseDynamicLink::LinkRenderer#render LinkRenderer#render for returned Hash
    def shorten_link(link, options = {})
      connection.timeout = options[:timeout] if options.key?(:timeout)
      connection.open_timeout = options[:open_timeout] if options.key?(:open_timeout)

      suffix_option = options[:suffix_option] if options.key?(:suffix_option)

      response = connection.post(nil, {
        longDynamicLink: build_link(link, options),
        suffix: {
          option: suffix_option || config.suffix_option
        }
      }.to_json)
      link_renderer.render(response)
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
      raise FirebaseDynamicLink::ConnectionError, e.message
    end

    # def shorten_object(_json_object)
    #   raise NotImplementedError
    # end

    private

    def_delegators :@link_renderer, :render_success, :raise_error
    def_delegators :FirebaseDynamicLink, :config

    attr_reader :link_renderer, :connection

    def build_link(link, options)
      dynamic_link_domain = options.delete(:dynamic_link_domain)
      dynamic_link_domain ||= config.dynamic_link_domain || raise(FirebaseDynamicLink::InvalidConfig, "Dynamic link domain is empty")
      "#{dynamic_link_domain}?link=#{link}"
    end

    def end_point
      "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=#{config.api_key}"
    end
  end
end
