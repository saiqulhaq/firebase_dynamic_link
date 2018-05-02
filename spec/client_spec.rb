# frozen_string_literal: true

RSpec.describe FirebaseDynamicLink::Client do
  before(:all) { FirebaseDynamicLink.reset_config }

  before do
    FirebaseDynamicLink.configure do |config|
      config.api_key = ENV["API_KEY"]
      config.dynamic_link_domain = ENV["DYNAMIC_LINK_DOMAIN"]
    end
  end

  xdescribe "#shorten_link" do
    it "shorten link correctly" do
      link = "http://saiqulhaq.com"
      VCR.use_cassette("shorten_link-SHORT") do
        options = { suffix_option: "SHORT" }
        result = subject.shorten_link(link, options)
        expect(result[:link]).to_not eq("")
        expect(result[:link]).to_not eq(link)
      end

      VCR.use_cassette("shorten_link-UNGUESSABLE") do
        options = { suffix_option: "UNGUESSABLE", timout: 5 }
        result = subject.shorten_link(link, options)
        expect(result[:link]).to_not eq("")
        expect(result[:link]).to_not eq(link)
      end
    end

    it "raise FirebaseDynamicLink::ConnectionError if Faraday::ConnectionFailed raised" do
      connection = Class.new do
        def post(*)
          raise Faraday::ConnectionFailed, "test"
        end
      end
      allow_any_instance_of(described_class).to receive(:connection).and_return(connection.new)
      expect do
        subject.shorten_link("http://saiqulhaq.com")
      end.to raise_error(FirebaseDynamicLink::ConnectionError)
    end

    it "raise FirebaseDynamicLink::ConnectionError if Faraday::TimeoutError raised" do
      connection = Class.new do
        def post(*)
          raise Faraday::TimeoutError, "test"
        end
      end
      allow_any_instance_of(described_class).to receive(:connection).and_return(connection.new)
      expect do
        subject.shorten_link("http://saiqulhaq.com")
      end.to raise_error(FirebaseDynamicLink::ConnectionError)
    end
  end

  fdescribe "#shorten_parameters" do
    it "shorten link correctly" do
      link = "http://saiqulhaq.com"
      string = "foo"
      VCR.use_cassette("shorten_parameters-SHORT") do
        options = {
          suffix_option: "SHORT" #,
          # dynamic_link_domain: 'foo' # optional
        }

        parameters = {
          link: link,
          android_info: {
            android_package_name: string,
            android_fallback_link: string,
            android_min_package_version_code: string,
            android_link: string
          },
          ios_info: {
            ios_bundle_id: string,
            ios_fallback_link: string,
            ios_custom_scheme: string,
            ios_ipad_fallback_link: string,
            ios_ipad_bundle_id: string,
            ios_app_store_id: string
          },
          navigation_info: {
            enable_forced_redirect: boolean,
          },
          analytics_info: {
            google_play_analytics: {
              utm_source: string,
              utm_medium: string,
              utm_campaign: string,
              utm_term: string,
              utm_content: string,
              gclid: string
            },
            itunes_connect_analytics: {
              at: string,
              ct: string,
              mt: string,
              pt: string
            }
          },
          social_meta_tag_info: {
            social_title: string,
            social_description: string,
            social_image_link: string
          }
        }
        result = subject.shorten_parameters(parameters, options)
        expect(result[:link]).to_not eq("")
        expect(result[:link]).to_not eq(link)
      end
    end
  end
end
