# frozen_string_literal: true

module FirebaseDynamicLink
  class Client
    attr_accessor :dynamic_link_domain

    # @param link String
    # @param options Hash
    # @return
    #   on succeed
    #   on failure
    #     status >= 400
    #     body {"error"=>{"code"=>400, "message"=>"Long link is not parsable: https://k4mu4.app.goo.gl?link=abcde [https://firebase.google.com/docs/dynamic-links/rest#create_a_short_link_from_parameters]", "status"=>"INVALID_ARGUMENT"}}
    def shorten_link(link, options = {})
      build_connection_options(connection, options)

      suffix_option = options.delete(:suffix_option)
      suffix_option ||= config.suffix_option

      response = connection.post(nil, {
        longDynamicLink: build_link(link, options),
        suffix: {
          option: suffix_option
        }
      }.to_json)
      if response.status.between?(200, 299)
        render_success(response)
      else
        raise_error(response)
      end
    rescue Faraday::ConnectionFailed, Faraday::TimeoutError => e
      raise FirebaseDynamicLink::ConnectionError, e.message
    end

    def shorten_object(_json_object)
      raise NotImplementedError
    end

    private

    def build_link(link, options)
      dynamic_link_domain = options.delete(:dynamic_link_domain)
      dynamic_link_domain ||= config.dynamic_link_domain || raise(FirebaseDynamicLink::InvalidConfig, "Dynamic link domain is empty")
      "#{dynamic_link_domain}?link=#{link}"
    end

    def build_connection_options(c, options)
      c.options.timeout = options.delete(:timeout) if options.key?(:timeout)
      c.options.open_timeout = options.delete(:open_timeout) if options.key?(:open_timeout)
      c
    end

    def connection
      @connection ||= Faraday::Connection.new(url: end_point,
                                              headers: { "Content-Type" => "application/json" })
    end

    def config
      ::FirebaseDynamicLink.config
    end

    def end_point
      "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=#{config.api_key}"
    end

    def raise_error(response)
      message = response.reason_phrase if response.respond_to?(:reason_phrase)
      if message.nil?
        message = begin
                    body = JSON.parse(response.body)
                    body["error"]["message"]
                  rescue StandardError
                    response.body
                  end
      end
      raise FirebaseDynamicLink::ConnectionError, message
    end

    def render_success(response)
      body = JSON.parse(response.body)
      has_error = body.key?("error")
      {
        link: has_error ? nil : body["shortLink"],
        preview_link: has_error ? nil : body["previewLink"],
        warning: has_error ? nil : body["warning"]
      }
    end
  end
end
