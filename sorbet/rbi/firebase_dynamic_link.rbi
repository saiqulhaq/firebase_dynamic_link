# typed: strong
# typed: true
# frozen_string_literal: true
module FirebaseDynamicLink
  extend Dry::Configurable
  USE_FARADAY_2 = T.let(Faraday::VERSION.to_i == 2, T.untyped)
  USE_DRY_CONFIGURABLE_0_13 = T.let(Dry::Configurable::VERSION.to_f >= 0.13, T.untyped)
  VERSION = T.let('2.0.1', T.untyped)

  # sord omit - no YARD return type given, using untyped
  # Given api key
  sig { returns(T.untyped) }
  def self.api_key; end

  # sord omit - no YARD return type given, using untyped
  # Set api key
  #
  # _@param_ `key`
  sig { params(key: String).returns(T.untyped) }
  def self.api_key=(key); end

  # sord omit - no YARD return type given, using untyped
  # Firebase dynamic link domain
  sig { returns(T.untyped) }
  def self.dynamic_link_domain; end

  # sord omit - no YARD return type given, using untyped
  # _@param_ `domain`
  sig { params(domain: String).returns(T.untyped) }
  def self.dynamic_link_domain=(domain); end

  # called when invalid configuration given
  class InvalidConfig < StandardError
  end

  # called when HTTP request failed
  class ConnectionError < StandardError
  end

  # called when Firebase says that no more quota
  class QuotaExceeded < StandardError
  end

  # Main class that responsible to shorten link or parameters
  class Client
    extend Forwardable

    # sord omit - no YARD type given for "api_key:", using untyped
    sig { params(api_key: T.untyped).void }
    def initialize(api_key: config.api_key); end

    # _@param_ `link` — required
    #
    # _@param_ `options` — * :timeout optional, default is FirebaseDynamicLink.config.timout * :open_timeout [Integer] optional, default is FirebaseDynamicLink.config.open_timout * :suffix_option [String] optional, default is FirebaseDynamicLink.config.suffix_option * :dynamic_link_domain [String] optional, default is FirebaseDynamicLink.config.dynamic_link_domain
    #
    # _@see_ `FirebaseDynamicLink::LinkRenderer#render` — LinkRenderer#render for returned Hash
    sig { params(link: String, options: T::Hash[T.untyped, T.untyped]).returns(T::Hash[Symbol, String]) }
    def shorten_link(link, options = {}); end

    # sord omit - no YARD type given for "options", using untyped
    # _@param_ `params` — * link [String] * android_info [Hash]   * android_package_name [String]   * android_fallback_link [String]   * android_min_package_version_code [String]   * android_link [String] * ios_info [Hash]   * ios_bundle_id [String]   * ios_fallback_link [String]   * ios_custom_scheme [String]   * ios_ipad_fallback_link [String]   * ios_ipad_bundle_id [String]   * ios_app_store_id [String] * navigation_info [Hash]   * enable_forced_redirect [Boolean] * analytics_info [Hash]   * google_play_analytics [Hash]     * utm_source [String]     * utm_medium [String]     * utm_campaign [String]     * utm_term [String]     * utm_content [String]     * gclid [String]   * itunes_connect_analytics [Hash]     * at [String]     * ct [String]     * mt [String]     * pt [String] * social_meta_tag_info [Hash]   * social_title [String]   * social_description [String]   * social_image_link [String]
    #
    # ```ruby
    # options = {
    #   suffix_option: "SHORT",
    #   dynamic_link_domain: 'domain' # optional
    # }
    #
    # parameters = {
    #   link: link,
    #   android_info: {
    #     android_package_name: string,
    #     android_fallback_link: string,
    #     android_min_package_version_code: string,
    #     android_link: string
    #   },
    #   ios_info: {
    #     ios_bundle_id: string,
    #     ios_fallback_link: string,
    #     ios_custom_scheme: string,
    #     ios_ipad_fallback_link: string,
    #     ios_ipad_bundle_id: string,
    #     ios_app_store_id: string
    #   },
    #   navigation_info: {
    #     enable_forced_redirect: boolean,
    #   },
    #   analytics_info: {
    #     google_play_analytics: {
    #       utm_source: string,
    #       utm_medium: string,
    #       utm_campaign: string,
    #       utm_term: string,
    #       utm_content: string,
    #       gclid: string
    #     },
    #     itunes_connect_analytics: {
    #       at: string,
    #       ct: string,
    #       mt: string,
    #       pt: string
    #     }
    #   },
    #   social_meta_tag_info: {
    #     social_title: string,
    #     social_description: string,
    #     social_image_link: string
    #   }
    # }
    # result = instance.shorten_parameters(parameters, options)
    # ```
    #
    # _@see_ `FirebaseDynamicLink::LinkRenderer#render` — LinkRenderer#render for returned Hash
    sig { params(params: T::Hash[T.untyped, T.untyped], options: T.untyped).returns(T::Hash[Symbol, String]) }
    def shorten_parameters(params, options = {}); end

    # sord omit - no YARD type given for "link", using untyped
    # sord omit - no YARD type given for "options", using untyped
    # sord omit - no YARD return type given, using untyped
    sig { params(link: T.untyped, options: T.untyped).returns(T.untyped) }
    def build_link(link, options); end

    # sord omit - no YARD type given for "api_key", using untyped
    # sord omit - no YARD return type given, using untyped
    sig { params(api_key: T.untyped).returns(T.untyped) }
    def end_point(api_key); end

    # sord omit - no YARD type given for :link_renderer, using untyped
    # Returns the value of attribute link_renderer.
    sig { returns(T.untyped) }
    attr_reader :link_renderer

    # sord omit - no YARD type given for :connection, using untyped
    # Returns the value of attribute connection.
    sig { returns(T.untyped) }
    attr_reader :connection
  end

  # Responsible to do HTTP request
  class Connection
    extend Forwardable

    # sord omit - no YARD return type given, using untyped
    # see Faraday::Connection#post
    sig { returns(T.untyped) }
    def post; end

    # sord omit - no YARD type given for "end_point", using untyped
    sig { params(end_point: T.untyped).void }
    def initialize(end_point); end

    # sord omit - no YARD type given for "time", using untyped
    # sord omit - no YARD return type given, using untyped
    #
    # _@see_ `Faraday.timeout=`
    sig { params(time: T.untyped).returns(T.untyped) }
    def timeout=(time); end

    # sord omit - no YARD return type given, using untyped
    #
    # _@see_ `Faraday.timeout`
    sig { returns(T.untyped) }
    def timeout; end

    # sord omit - no YARD type given for "time", using untyped
    # sord omit - no YARD return type given, using untyped
    #
    # _@see_ `Faraday.open_timeout=`
    sig { params(time: T.untyped).returns(T.untyped) }
    def open_timeout=(time); end

    # sord omit - no YARD return type given, using untyped
    #
    # _@see_ `Faraday.open_timeout`
    sig { returns(T.untyped) }
    def open_timeout; end

    # sord omit - no YARD type given for :client, using untyped
    # Returns the value of attribute client.
    sig { returns(T.untyped) }
    attr_reader :client
  end

  # Responsible to formatting output of Client#shorten_link
  class LinkRenderer
    # sord warn - Faraday::Connection wasn't able to be resolved to a constant in this project
    # sord warn - "String or Hash" does not appear to be a type
    # _@param_ `response` — http reponse
    #
    # _@return_ — Hash<Symbol, String or Hash>
    #
    # ```ruby
    # {
    #   :link => short link result
    #   :preview_link => preview of short link result
    #   :warning => warning message by Firebase if present
    # }
    # ```
    sig { params(response: Faraday::Connection).returns(T::Hash[Symbol, SORD_ERROR_StringorHash]) }
    def render(response); end

    # sord omit - no YARD type given for "response", using untyped
    # sord omit - no YARD return type given, using untyped
    sig { params(response: T.untyped).returns(T.untyped) }
    def render_success(response); end

    # sord omit - no YARD type given for "response", using untyped
    # sord omit - no YARD return type given, using untyped
    sig { params(response: T.untyped).returns(T.untyped) }
    def raise_error(response); end

    # sord omit - no YARD return type given, using untyped
    sig { returns(T.untyped) }
    def raise_limit_has_reached; end
  end
end
