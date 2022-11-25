# typed: false
# frozen_string_literal: true

require "faraday"

RSpec.describe FirebaseDynamicLink do
  before(:all) { described_class.reset_config }

  it "has a version number" do
    expect(FirebaseDynamicLink::VERSION).to eq("2.0.1")
  end

  describe ".config" do
    subject { described_class.config }

    {
      adapter: {
        default: Faraday.default_adapter,
        valid_value: :net_http
      },
      api_key: {
        default: nil,
        valid_value: "foobar"
      },
      dynamic_link_domain: {
        default: nil,
        valid_value: "http://asd.com/asd"
      },
      timeout: {
        default: 3,
        valid_value: 2
      },
      open_timeout: {
        default: 3,
        valid_value: 1
      },
      suffix_option: {
        default: "UNGUESSABLE",
        valid_value: "SHORT"
      }
    }.each do |method, meta|
      describe ".#{method}" do
        it "default value is #{meta[:default].nil? ? 'nil' : meta[:default]}" do
          if subject.respond_to? :values
            expect(subject.values[method]).to eq(meta[:default])
          else
            expect(subject.send(method)).to eq(meta[:default])
          end
        end

        it "is writable" do
          subject.send("#{method}=".to_sym, meta[:valid_value])
          if subject.respond_to? :values
            expect(subject.values[method]).to eq(meta[:valid_value])
          else
            expect(subject.send(method.to_sym)).to eq(meta[:valid_value])
          end
        end
      end
    end

    describe "suffix_option=" do
      it "raises FirebaseDynamicLink::InvalidConfig if given parameter is not valid" do
        expect { subject.suffix_option = "FOO" }.to raise_error(FirebaseDynamicLink::InvalidConfig)
      end
    end
  end
end
