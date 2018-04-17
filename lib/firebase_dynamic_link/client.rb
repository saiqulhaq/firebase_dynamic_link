module FirebaseDynamicLink
  class Client
    attr_accessor :dynamic_link_domain

    # on succeed
    #
    # on failure
    #   status >= 400
    #   body {"error"=>{"code"=>400, "message"=>"Long link is not parsable: https://k4mu4.app.goo.gl?link=abcde [https://firebase.google.com/docs/dynamic-links/rest#create_a_short_link_from_parameters]", "status"=>"INVALID_ARGUMENT"}}
    def shorten_link(link, options = {})
      suffix_option = options.delete(:suffix_option)
      suffix_option ||= config.default.suffix.option
      dynamic_link_domain = options.delete(:dynamic_link_domain)
      dynamic_link_domain ||= config.default.dynamic_link_domain || raise(FirebaseDynamicLink::InvalidConfig, 'Dynamic link domain is empty')
      link = "#{dynamic_link_domain}?link=#{link}"
      response = connection.post(nil, {
        longDynamicLink: link,
        suffix: {
          option: suffix_option
        }
      }.to_json)
      body = JSON.parse(response.body)
      has_error = body.key?('error')
      {
        success: !has_error,
        link: has_error ? nil : body['shortLink'],
        preview_link: has_error ? nil : body['previewLink'],
        warning: has_error ? nil : body['warning'],
        error_message: has_error ? body['error']['message'] : nil,
        error_status: has_error ? body['error']['status'] : nil,
        error_code: has_error ? body['error']['code'] : nil
      }
    end

    def shorten_object(_json_object)
      raise NotImplementedError
    end

    private

    def connection
      con = Faraday::Connection.new(url: end_point,
                                    headers: { 'Content-Type' => 'application/json' })
      con
    end

    def config
      ::FirebaseDynamicLink.config
    end

    def end_point
      "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=#{config.api_key}"
    end
  end
end
