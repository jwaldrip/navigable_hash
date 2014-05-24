require 'spec_helper'
require 'pry'
require 'helpers/helper_methods'

RSpec.configure do |c|
  c.extend NavigableHash::HelperMethods
end

describe NavigableHash do

  TEST_HASH = { :symbol_key => 'symbol_key_value', 'string_key' => 'string_key_value', :hash_item => { :inner_value => true }, :array => [ {}, 'string', :symbol ] , :nil_value => nil, :object => Object.new }

  describe ".new" do
    context "given an array" do
      it "should not raise an error" do
        expect { NavigableHash.new([:a, 1]) }.to_not raise_error
      end
    end

    context "given a hash" do
      it "should not raise an error" do
        expect { NavigableHash.new({:a => 1}) }.to_not raise_error
      end
    end

    context "given a block" do
      it "should not raise an error" do
        expect do
          NavigableHash.new do |v|
            v.foo = :bar
          end
        end.to_not raise_error
      end

      it "should create a new navigable hash" do
        navigable = NavigableHash.new do |v|
        end
        expect(navigable).to be_a NavigableHash
      end

      it "should assign values in the block to the hash" do
        navigable = NavigableHash.new do |v|
          v.foo = :bar
        end
        expect(navigable.foo).to eq :bar
      end
    end
  end

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
  subject(:navigable){ NavigableHash.new(hash) }

  context "with a deep setter" do
    let(:hash){ {} }
    it "should be able to set and get a deep value" do
      value = "world"
      navigable.foo = {}
      navigable.foo.bar = {}
      navigable.foo.bar.baz = value
      expect(navigable.foo.bar.baz).to eq value
    end
  end

  describe "#__any_method__" do
    it "should not raise an error" do
      expect { navigable.__any_method__ }.to_not raise_error
    end

    it "should get a value" do
      navigable.__any_method__ = "foo"
      expect(navigable.__any_method__).to eq "foo"
    end

    it "should raise an error with arguments" do
      expect {
        $pry = true
        navigable.__any_method__ :foo
      }.to raise_error
    end

    context "given a block" do
      it "should not raise an error" do
        expect do
          navigable.__any_method__ do |v|
            v.foo = :bar
          end
        end.to_not raise_error
      end

      it "should create a new navigable hash" do
        navigable.__any_method__ do |v|
        end
        expect(navigable.__any_method__).to be_a NavigableHash
      end

      it "should assign values in the block to the hash" do
        navigable.__any_method__ do |v|
          v.foo = :bar
        end
        expect(navigable.__any_method__.foo).to eq :bar
      end
    end

  end

  describe "#__any_method__=" do
    it "should not raise an error" do
      expect { navigable.__any_method__ = 'value' }.to_not raise_error
    end

    it "should set a value" do
      expect { navigable.__any_method__ = 'value' }.to change { navigable[:__any_method__] }
    end

    it "should raise an error with more than one argument" do
      expect { navigable.send :__any_method__, :foo, :bar }.to raise_error
    end
  end

  describe "#[]" do

    context "given a hash" do
      it "should return a new instance of navigable hash" do
        expect(navigable[:hash_item]).to be_an_instance_of NavigableHash
      end
    end

    context "given an array" do
      it "should call #navigate with each value" do
        expect(navigable[:array]).to be_a Array
      end
    end

    context "given any object" do
      it "should return a value" do
        expect(navigable[:object]).to be_an_instance_of Object
      end
    end

    context "given nil" do
      it "should return a value" do
        expect(navigable[:nil_value]).to be_nil
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
        expect(navigable).to receive(:navigate_hash).with(hash).and_call_original
        navigable[:hash] = hash
        expect(navigable[:hash]).to be_an_instance_of NavigableHash
      end

      context "given a subclass, setting with a navigable hash" do
        before(:each) do
          stub_const 'SubNavigableHash', Class.new(NavigableHash)
        end
        subject(:navigable){ SubNavigableHash.new(hash) }
        it 'should return an instance of the subclass' do
          hash = NavigableHash.new :a => 1, :b => 2, :c => 3
          expect(navigable).to receive(:navigate_hash).with(hash).and_call_original
          navigable[:hash] = hash
          expect(navigable[:hash]).to be_an_instance_of SubNavigableHash
        end
      end
    end

    context "given an array" do
      it "should call #navigate with each value" do
        array = [1, 2, 3]
        expect(navigable).to receive(:navigate_array).with(array)
        navigable[:array] = array
      end
    end

    context "given any object" do
      it "should return a value" do
        object = Object.new
        expect(navigable).to receive(:navigate_value).with(object)
        navigable[:object] = object
      end
    end

    context "given nil" do
      it "should return a value" do
        expect(navigable).to receive(:navigate_value).with(nil)
        navigable[:nil_value] = nil
      end
    end
  end

  describe "#==" do
    it "should be equal to a hash" do
      expect(navigable).to eq hash
    end
  end

  describe "#delete" do
    context "given a string as the key" do
      it "should delete a value" do
        expect { navigable.delete('hash_item') }.to change { navigable[:hash_item] }.to(nil)
      end
    end

    context "given a symbol as the key" do
      it "should delete a value" do
        expect { navigable.delete(:hash_item) }.to change { navigable[:hash_item] }.to(nil)
      end
    end
  end


  describe "#dup" do
    it "should return a copy of navigable hash" do
      expect(navigable.dup).to be_an_instance_of NavigableHash
    end

    it "should be equal to its original" do
      expect(navigable.dup).to eq navigable
    end
  end

  describe "#key?" do
    context "if a key exists" do
      it "should be true" do
        navigable[:present_key] = 'value'
        expect(navigable.key? :present_key).to be_true
      end
    end

    context "if a key does not exist" do
      it "should be false" do
        expect(navigable.key? :no_key).to be_false
      end
    end
  end

  describe "#fetch" do
    context "given a hash" do
      let(:hash){ { :hash => {} } }
      it "should return an instance of NavigableHash" do
        expect(navigable.fetch :hash).to be_an_instance_of NavigableHash
      end
    end
  end

  describe "#merge" do
    context "given a hash" do
      it "should have a navigable hash" do
        merged = navigable.merge({ :some_hash => {}})
        expect(merged[:some_hash]).to be_an_instance_of NavigableHash
      end
    end
  end

  describe "#to_hash" do
    it "should be an instance of Hash" do
      expect(navigable.to_hash).to be_an_instance_of Hash
    end

    it "inner hash should be an instance of hash" do
      expect(navigable[:hash_item]).to be_an_instance_of NavigableHash
      expect(navigable.to_hash['hash_item']).to be_an_instance_of Hash
    end
  end

  describe "#update" do
    context "given a hash" do
      it "should have a navigable hash" do
        navigable.update({ :some_hash => {}})
        expect(navigable[:some_hash]).to be_an_instance_of NavigableHash
      end
    end
  end

  describe "#respond_to?" do
    context "if the key exists" do
      it "should be " do
        expect(navigable).to_not respond_to :this_is_not_a_method
      end
    end

    context "if the key does not exist" do
      it "should be " do
        navigable[:this_is_not_a_method] = "Hello"
        expect(navigable).to respond_to :this_is_not_a_method
      end
    end

    context "with a real method" do
      it "should be true" do
        expect(navigable).to respond_to :to_hash
      end
    end
  end

  describe "#values_at" do
    let (:hash){ { :foo => "foo_value", :bar => "bar_value", :baz => "baz_value" } }
    it "should have the correct values" do
      expect(navigable.values_at :foo, :bar).to eq [hash[:foo], hash[:bar]]
    end
  end

  describe "#method_missing" do
    it "should return nil" do
      expect(navigable.this_is_not_a_method).to be_nil
    end

    it "should not raise an error" do
      expect { navigable.this_is_not_a_method }.to_not raise_error
    end
  end

end
