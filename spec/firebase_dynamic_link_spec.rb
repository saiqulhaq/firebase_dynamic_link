RSpec.describe FirebaseDynamicLink do
  it 'has a version number' do
    expect(FirebaseDynamicLink::VERSION).not_to be nil
  end

  describe '#config' do
    subject { described_class.config }
    it 'has adapter attributes' do
      is_expected.to respond_to(:adapter)
      is_expected.to respond_to(:adapter=)

      subject.adapter = :foo
      expect(subject.adapter).to eq(:foo)
    end
  end
end
