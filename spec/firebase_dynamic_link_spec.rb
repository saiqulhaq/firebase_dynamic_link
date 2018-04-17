require 'faraday'

RSpec.describe FirebaseDynamicLink do
  it 'has a version number' do
    expect(FirebaseDynamicLink::VERSION).to eq('0.1.0')
  end

  describe '#config' do
    subject { described_class.config }

    it { is_expected.to respond_to(:api_key) }
    it { is_expected.to respond_to(:api_key=) }

    describe '#adapter' do
      it 'default value is Faraday.default_adapter' do
        expect(subject.adapter).to eq(Faraday.default_adapter)
      end
    end

    describe '#default' do
      subject { described_class.config.default }

      it { is_expected.to respond_to(:dynamic_link_domain) }
      it { is_expected.to respond_to(:dynamic_link_domain=) }

      describe '#suffix' do
        subject { described_class.config.default.suffix }

        it { is_expected.to respond_to(:option) }
        it { is_expected.to respond_to(:option=) }
        it 'accepts SHORT and UNGUESSABLE option only' do
          subject.option = 'SHORT'
          expect(subject.option).to eq('SHORT')

          subject.option = 'UNGUESSABLE'
          expect(subject.option).to eq('UNGUESSABLE')

          expect { subject.option = 'foo' }.to raise_error(FirebaseDynamicLink::InvalidConfig)
        end
      end
    end
  end
end
