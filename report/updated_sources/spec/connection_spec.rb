# typed: false
# frozen_string_literal: true

RSpec.describe FirebaseDynamicLink::Connection do
  subject { instance }

  let(:instance) { described_class.new("http://saiqulhaq.com") }

  describe "#timeout" do
    it "uses default config timeout as default" do
      expect(instance.timeout).to eq(FirebaseDynamicLink.config.timeout)
    end

    it "configurable" do
      instance.timeout = 10
      expect(instance.timeout).to eq(10)
    end
  end

  describe "#open_timeout" do
    it "uses default config open_timeout as default" do
      expect(instance.open_timeout).to eq(FirebaseDynamicLink.config.open_timeout)
    end

    it "configurable" do
      instance.open_timeout = 8
      expect(instance.open_timeout).to eq(8)
    end
  end

  it { is_expected.to respond_to(:post) }
end
