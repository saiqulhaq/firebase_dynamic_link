# frozen_string_literal: true

RSpec.describe FirebaseDynamicLink::LinkRenderer do
  let(:success_response) do
    OpenStruct.new(status: 200, body: {
      shortLink: 'http://link',
      previewLink: 'http://xxx.goo.gl/foo?preview',
      warning: [{
        'warningCode' => 'UNRECOGNIZED_PARAM',
        'warningMessage' => '...'
      }]
    }.to_json)
  end

  let(:fail_response) do
    OpenStruct.new(status: [422, 500].sample, body: {
      error: {
        message: 'xxx'
      }
    }.to_json)
  end

  let(:instance) { described_class.new }

  describe '#render' do
    context 'when response is success' do
      it 'parsed output correctly' do
        output = instance.render(success_response)
        expect(output).to have_key(:link)
        expect(output).to have_key(:preview_link)
        expect(output).to have_key(:warning)
        expect(output[:link]).to eq('http://link')
      end

      it 'raise error if response body has error key' do
        success_response.body = JSON.parse(success_response.body).merge(error: 'foo').to_json
        expect do
          instance.render(success_response)
        end.to raise_error(FirebaseDynamicLink::ConnectionError)
      end
    end

    context 'when response is fail' do
      it 'raises error' do
        expect do
          instance.render(fail_response)
        end.to raise_error(FirebaseDynamicLink::ConnectionError)
      end

      it 'render response.body if response.body.error.message is not exist' do
        fail_response.body = 'foobar'
        expect do
          instance.render(fail_response)
        end.to raise_error(FirebaseDynamicLink::ConnectionError)
      end
    end

    context 'when response.status is 429' do
      it 'raise FirebaseDynamicLink::QuotaExceeded' do
        response = fail_response
        response.status = 429
        expect do
          instance.render(response)
        end.to raise_error(FirebaseDynamicLink::QuotaExceeded)
      end
    end
  end
end
