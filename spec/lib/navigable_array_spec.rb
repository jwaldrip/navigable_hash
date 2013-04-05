require 'spec_helper'

describe NavigableArray do

  let(:primer) { [{ foo: 'foo1'}, { foo: 'foo2'}, { foo: 'foo3'}] }
  let(:navigable) { NavigableArray.new primer }

  describe "#__any_method__" do
    context "When there is an array of hashes" do
      it "should map the hash keys" do
        navigable.foo.should == ['foo1', 'foo2', 'foo3']
      end
    end
  end

  describe "#respond_to?" do
    it "should always be true" do
      navigable.respond_to?(:not_a_real_method).should be_true
    end
  end

end