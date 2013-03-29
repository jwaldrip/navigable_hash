require 'spec_helper'
require 'pry'
require 'helpers/helper_methods'

RSpec.configure do |c|
  c.extend NavigableHash::HelperMethods
end

describe NavigableHash do

  TEST_HASH = { :symbol_key => 'symbol_key_value', 'string_key' => 'string_key_value', :hash_item => { :inner_value => true }, :array => [ {}, 'string', :symbol ] , :nil_value => nil, :object => Object.new }

  describe ".new(TEST_HASH)" do
    context "with dot notation" do
      TEST_HASH.keys.each do |key_name|
        test_key_with_dot_notation(key_name, TEST_HASH)
      end
    end

    context "with symbol notation" do
      TEST_HASH.keys.each do |key_name|
        test_key_with_symbol_notation(key_name, TEST_HASH)
      end
    end

    context "with string notation" do
      TEST_HASH.keys.each do |key_name|
        test_key_with_string_notation(key_name, TEST_HASH)
      end
    end
  end

  let(:hash){ TEST_HASH }
  let(:navigable){ NavigableHash.new(hash) }

  context "with a deep setter" do
    let(:hash){ {} }
    it "should be able to set and get a deep value" do
      value = "world"
      navigable.foo = {}
      navigable.foo.bar = {}
      navigable.foo.bar.baz = value
      navigable.foo.bar.baz.should == value
    end
  end

  describe "#__any_method__" do
    it "should not raise an error" do
      expect { navigable.__any_method__ }.to_not raise_error
    end

    it "should get a value" do
      navigable.__any_method__ = "foo"
      navigable.__any_method__.should == "foo"
    end

    it "should raise an error with arguments" do
      expect { navigable.__any_method__ :foo }.to raise_error
    end
  end

  describe "#__any_method__=" do
    it "should not raise an error" do
      expect { navigable.__any_method__ = 'value' }.to_not raise_error
    end

    it "should set a value" do
      expect { navigable.__any_method__ = 'value' }.to change { navigable.__any_method__ }
    end

    it "should raise an error with more than one argument" do
      expect { navigable.send :__any_method__, :foo, :bar }.to raise_error
    end
  end

  describe "#[]" do

    context "given a hash" do
      it "should return a new instance of navigable hash" do
        navigable[:hash_item].should be_an_instance_of NavigableHash
      end
    end

    context "given an array" do
      it "should call #navigate with each value" do
        navigable[:array].should be_a Array
      end
    end

    context "given any object" do
      it "should return a value" do
        navigable[:object].should be_an_instance_of Object
      end
    end

    context "given nil" do
      it "should return a value" do
        navigable[:nil_value].should be_nil
      end
    end

  end

  describe "#[]=" do
    it "should set a value" do
      expect { navigable[:new_key] = 'value' }.to change { navigable[:new_key] }
    end

    context "given a hash" do
      it "should return a new instance of navigable hash" do
        hash = {:a => 1, :b => 2, :c => 3}
        navigable.should_receive(:navigate_hash).with(hash)
        navigable[:hash] = hash
      end
    end

    context "given an array" do
      it "should call #navigate with each value" do
        array = [1, 2, 3]
        navigable.should_receive(:navigate_array).with(array)
        navigable[:array] = array
      end
    end

    context "given any object" do
      it "should return a value" do
        object = Object.new
        navigable.should_receive(:navigate_value).with(object)
        navigable[:object] = object
      end
    end

    context "given nil" do
      it "should return a value" do
        navigable.should_receive(:navigate_value).with(nil)
        navigable[:nil_value] = nil
      end
    end
  end

  describe "#==" do
    it "should be equal to a hash" do
      navigable.should == hash
    end
  end

  describe "#dup" do
    it "should return a copy of navigable hash" do
      navigable.dup.should be_an_instance_of NavigableHash
    end

    it "should be equal to its original" do
      navigable.dup.should == navigable
    end
  end

  describe "#fetch" do
    context "given a hash" do
      let(:hash){ { :hash => {} } }
      it "should return an instance of NavigableHash" do
        navigable.fetch(:hash).should be_an_instance_of NavigableHash
      end
    end
  end

  describe "#merge" do
    context "given a hash" do
      it "should have a navigable hash" do
        merged = navigable.merge({ :some_hash => {}})
        merged[:some_hash].should be_an_instance_of NavigableHash
      end
    end
  end

  describe "to_hash" do
    it "should be an instance of Hash" do
      navigable.to_hash.should be_an_instance_of Hash
    end

    it "inner hash should be an instance of hash" do
      navigable[:hash_item].should be_an_instance_of NavigableHash
      navigable.to_hash['hash_item'].should be_an_instance_of Hash
    end
  end

  describe "#update" do
    context "given a hash" do
      it "should have a navigable hash" do
        navigable.update({ :some_hash => {}})
        navigable[:some_hash].should be_an_instance_of NavigableHash
      end
    end
  end

  describe "#respond_to?" do
    it "should always be true" do
      navigable.respond_to?(:this_is_not_a_method).should be_true
    end
  end

  describe "#method_missing" do
    it "should return nil" do
      navigable.this_is_not_a_method.should be_nil
    end

    it "should not raise an error" do
      expect { navigable.this_is_not_a_method }.to_not raise_error
    end
  end

end
