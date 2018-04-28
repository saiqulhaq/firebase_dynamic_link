# frozen_string_literal: true

RSpec.describe FirebaseDynamicLink::Client do
  before(:all) { FirebaseDynamicLink.reset_config }

  before do
    FirebaseDynamicLink.configure do |config|
      config.api_key = ENV["API_KEY"]
      config.dynamic_link_domain = ENV["DYNAMIC_LINK_DOMAIN"]
    end
  end

  describe "#shorten_link" do
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

    it 'raise FirebaseDynamicLink::ConnectionError if Faraday::ConnectionFailed raised' do
      connection = Class.new do
        def post(*)
          raise Faraday::ConnectionFailed, 'test'
        end
      end
      allow_any_instance_of(described_class).to receive(:connection).and_return(connection.new)
      expect {
        subject.shorten_link('http://saiqulhaq.com')
      }.to raise_error(FirebaseDynamicLink::ConnectionError)
    end

    it 'raise FirebaseDynamicLink::ConnectionError if Faraday::TimeoutError raised' do
      connection = Class.new do
        def post(*)
          raise Faraday::TimeoutError, 'test'
        end
      end
      allow_any_instance_of(described_class).to receive(:connection).and_return(connection.new)
      expect {
        subject.shorten_link('http://saiqulhaq.com')
      }.to raise_error(FirebaseDynamicLink::ConnectionError)
    end
  end

  # describe "#shorten_object" do
  # end
end
