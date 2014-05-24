module NavigableHash::HelperMethods

  def test_key_with_dot_notation(key, hash)
    case (value = hash[key])
    when Hash
      value.keys.each { |key| test_key_with_dot_notation key, hash }
    end
    describe "##{key}" do
      it "should call navigate" do
        navigable.stub(:navigate)
        navigable.send(key)
      end

      it "should have a valid value" do
        expect(navigable.send key).to eq hash[key]
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
        navigable.stub(:navigate)
        navigable[key.to_sym]
      end

      it "should have a valid value" do
        expect(navigable[key.to_sym]).to eq hash[key]
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
        navigable.stub(:navigate)
        navigable[key.to_s]
      end

      it "should have a valid value" do
        expect(navigable[key.to_s]).to eq hash[key]
      end
    end
  end

end