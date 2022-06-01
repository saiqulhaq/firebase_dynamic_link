# typed: true
# frozen_string_literal: true

require "uri"
require "firebase_dynamic_link/connection"
require "firebase_dynamic_link/link_renderer"
require "case_transform2"

module FirebaseDynamicLink
  # Main class that responsible to shorten link or parameters
  class Client
    extend Forwardable

    def initialize(api_key: config.api_key)
      @link_renderer = FirebaseDynamicLink::LinkRenderer.new
      short_links_url = end_point(api_key)
      @connection = FirebaseDynamicLink::Connection.new(short_links_url)
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

      params = CaseTransform2.camel_lower(long_dynamic_link: build_link(link, options),
                                          suffix: {
                                            option: suffix_option || config.suffix_option
                                          })
      response = connection.post(nil, params.to_json)
      link_renderer.render(response)
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
      raise FirebaseDynamicLink::ConnectionError, e.message
    end

    # @param params [Hash]
    #   * link [String]
    #   * android_info [Hash]
    #     * android_package_name [String]
    #     * android_fallback_link [String]
    #     * android_min_package_version_code [String]
    #     * android_link [String]
    #   * ios_info [Hash]
    #     * ios_bundle_id [String]
    #     * ios_fallback_link [String]
    #     * ios_custom_scheme [String]
    #     * ios_ipad_fallback_link [String]
    #     * ios_ipad_bundle_id [String]
    #     * ios_app_store_id [String]
    #   * navigation_info [Hash]
    #     * enable_forced_redirect [Boolean]
    #   * analytics_info [Hash]
    #     * google_play_analytics [Hash]
    #       * utm_source [String]
    #       * utm_medium [String]
    #       * utm_campaign [String]
    #       * utm_term [String]
    #       * utm_content [String]
    #       * gclid [String]
    #     * itunes_connect_analytics [Hash]
    #       * at [String]
    #       * ct [String]
    #       * mt [String]
    #       * pt [String]
    #   * social_meta_tag_info [Hash]
    #     * social_title [String]
    #     * social_description [String]
    #     * social_image_link [String]
    # @example
    #   options = {
    #     suffix_option: "SHORT",
    #     dynamic_link_domain: 'domain' # optional
    #   }
    #
    #   parameters = {
    #     link: link,
    #     android_info: {
    #       android_package_name: string,
    #       android_fallback_link: string,
    #       android_min_package_version_code: string,
    #       android_link: string
    #     },
    #     ios_info: {
    #       ios_bundle_id: string,
    #       ios_fallback_link: string,
    #       ios_custom_scheme: string,
    #       ios_ipad_fallback_link: string,
    #       ios_ipad_bundle_id: string,
    #       ios_app_store_id: string
    #     },
    #     navigation_info: {
    #       enable_forced_redirect: boolean,
    #     },
    #     analytics_info: {
    #       google_play_analytics: {
    #         utm_source: string,
    #         utm_medium: string,
    #         utm_campaign: string,
    #         utm_term: string,
    #         utm_content: string,
    #         gclid: string
    #       },
    #       itunes_connect_analytics: {
    #         at: string,
    #         ct: string,
    #         mt: string,
    #         pt: string
    #       }
    #     },
    #     social_meta_tag_info: {
    #       social_title: string,
    #       social_description: string,
    #       social_image_link: string
    #     }
    #   }
    #   result = instance.shorten_parameters(parameters, options)
    # @return [Hash{Symbol=>String}]
    # @see FirebaseDynamicLink::LinkRenderer#render LinkRenderer#render for returned Hash
    def shorten_parameters(params, options = {})
      connection.timeout = options[:timeout] if options.key?(:timeout)
      connection.open_timeout = options[:open_timeout] if options.key?(:open_timeout)

      suffix_option = options[:suffix_option] if options.key?(:suffix_option)

      dynamic_link_domain = options.delete(:dynamic_link_domain)
      dynamic_link_domain ||= config.dynamic_link_domain || raise(FirebaseDynamicLink::InvalidConfig,
                                                                  "Dynamic link domain is empty")

      params = CaseTransform2.camel_lower(dynamic_link_info: params.merge(domainUriPrefix: dynamic_link_domain),
                                          suffix: {
                                            option: suffix_option || config.suffix_option
                                          })
      response = connection.post(nil, params.to_json)
      link_renderer.render(response)
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
      raise FirebaseDynamicLink::ConnectionError, e.message
    end

    private

    def_delegators :@link_renderer, :render_success, :raise_error
    def_delegators :FirebaseDynamicLink, :config

    attr_reader :link_renderer, :connection

    def build_link(link, options)
      dynamic_link_domain = options.delete(:dynamic_link_domain)
      dynamic_link_domain ||= config.dynamic_link_domain || raise(FirebaseDynamicLink::InvalidConfig,
                                                                  "Dynamic link domain is empty")
      "#{dynamic_link_domain}?link=#{link}"
    end

    def end_point(api_key)
      "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=#{api_key}"
    end
  end
end
