# frozen_string_literal: true

module FirebaseDynamicLink
  # Responsible to formatting output of Client#shorten_link
  class LinkRenderer
    # @param response [Faraday::Connection] http reponse
    # @return [Hash<Symbol, String or Hash>
    # @example
    #   {
    #     :link => short link result
    #     :preview_link => preview of short link result
    #     :warning => warning message by Firebase if present
    #   }
    # @raise FirebaseDynamicLink::ConnectionError if there is something wrong with Faraday request
    # @raise FirebaseDynamicLink::QuotaExceeded if request reached Google Firebase quota
    def render(response)
      if response.status.between?(200, 299)
        render_success(response)
      elsif response.status == 429
        raise_limit_has_reached
      else
        raise_error(response)
      end
    end

    private

    def render_success(response)
      body = JSON.parse(response.body)
      return raise_error(response) if body.key?('error')

      {
        link: body['shortLink'],
        preview_link: body['previewLink'],
        warning: body['warning']
      }
    end

    def raise_error(response)
      reason = response.reason_phrase.to_s if response.respond_to?(:reason_phrase)
      message = begin
        body = JSON.parse(response.body)
        body['error']['message']
      rescue JSON::ParserError, NoMethodError
        response.body
      end
      raise FirebaseDynamicLink::ConnectionError, [reason, message].compact.join(': ')
    end

    def raise_limit_has_reached
      raise FirebaseDynamicLink::QuotaExceeded, 'Request limit has been reached'
    end
  end
end
