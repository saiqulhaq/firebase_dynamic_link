RSpec.describe FirebaseDynamicLink::Client do
  let(:instance) { described_class.new }
  before do
    FirebaseDynamicLink.configure do |config|
      config.api_key = ENV['API_KEY']
      config.default.dynamic_link_domain = ENV['DYNAMIC_LINK_DOMAIN']
    end
  end

  describe '#shorten_link' do
    it 'shorten link correctly' do
      link = 'http://saiqulhaq.com'
      VCR.use_cassette('shorten_link') do
        option = { suffix_option: 'SHORT' }
        result = instance.shorten_link(link, option)
        expect(result[:success]).to be_truthy
        expect(result[:link]).to_not eq('')
        puts result
      end
    end

    it 'raise FirebaseDynamicLink::Error if link is invalid' do
      link = 'abcde'
      VCR.use_cassette('shorten_link_error') do
        result = instance.shorten_link(link)
        expect(result[:success]).to be_falsey
        expect(result[:link]).to be_nil
        puts result
      end
    end
  end

  describe '#shorten_object' do
  end
end
