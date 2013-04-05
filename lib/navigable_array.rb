require 'navigable_hash'

class NavigableArray < Array

  def initialize(array=[])
    super(array).map! do |value|
      case value
      when Array
        self.class.new value
      when Hash
        NavigableHash.new value
      else
        value
      end
    end
  end

  def respond_to?(m, include_private = false)
    true
  end

  def method_missing(m, *args, &block)
    self.class.new select { |v| v.is_a?(Hash) && v.has_key?(m) }.map { |v| v[m] }
  end

end