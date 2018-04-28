# frozen_string_literal: true

RSpec.describe FirebaseDynamicLink::Client do
  let(:instance) { described_class.new }
  before do
    FirebaseDynamicLink.configure do |config|
      config.api_key = ENV["API_KEY"]
      config.default.dynamic_link_domain = ENV["DYNAMIC_LINK_DOMAIN"]
    end
  end

  describe "#shorten_link" do
    it "shorten link correctly" do
      link = "http://saiqulhaq.com"
      VCR.use_cassette("shorten_link") do
        option = { suffix_option: "SHORT" }
        result = instance.shorten_link(link, option)
        expect(result[:link]).to_not eq("")
        expect(result[:link]).to_not eq(link)
      end
    end

    it "raise FirebaseDynamicLink::Error if link is invalid" do
      link = "abcde"
      VCR.use_cassette("shorten_link_error") do
        expect { instance.shorten_link(link) }.to raise_error(FirebaseDynamicLink::ConnectionError)
      end
    end

    it "raises error if exceeding timeout" do
      options = {
        open_timeout: 1,
        timeout: 1
      }
      %w[
        https://httpstat.us/524
        https://httpstat.us/504
        https://httpstat.us/522
        https://httpstat.us/408
      ].each do |link|
        allow(instance).to receive(:end_point).and_return(link)
        expect { instance.shorten_link("", options) }.to raise_error(FirebaseDynamicLink::ConnectionError)
      end
    end
  end

  describe "#shorten_object" do
  end
end
