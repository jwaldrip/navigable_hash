module NavigableHash::HelperMethods

  def test_key_with_dot_notation(key, hash)
    case (value = hash[key])
    when Hash
      value.keys.each { |key| test_key_with_dot_notation key, hash }
    end
    describe "##{key}" do
      it "should call navigate" do
        navigable.should_receive(:navigate).any_number_of_times
        navigable.send(key)
      end

      it "should have a valid value" do
        navigable.send(key).should == hash[key]
      end
    end
  end

  def test_key_with_symbol_notation(key, hash)
    case (value = hash[key])
    when Hash
      value.keys.each { |key| test_key_with_dot_notation key, hash }
    end
    describe "##{key}" do
      it "should call navigate" do
        navigable.should_receive(:navigate).any_number_of_times
        navigable[key.to_sym]
      end

      it "should have a valid value" do
        navigable[key.to_sym].should == hash[key]
      end
    end
  end

  def test_key_with_string_notation(key, hash)
    case (value = hash[key])
    when Hash
      value.keys.each { |key| test_key_with_dot_notation key, hash }
    end
    describe "##{key}" do
      it "should call navigate" do
        navigable.should_receive(:navigate).any_number_of_times
        navigable[key.to_s]
      end

      it "should have a valid value" do
        navigable[key.to_s].should == hash[key]
      end
    end
  end

end