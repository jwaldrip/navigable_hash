require 'active_support/core_ext/hash'
require "active_support/hash_with_indifferent_access"

class NavigableHash < HashWithIndifferentAccess

  VERSION = "0.0.1"

  def [](key)
    navigate super(key)
  end

  def method_missing(m, *args, &block)
    self[m]
  end

  def respond_to_missing?(m, include_private = false)
    true
  end

  def ==(other_hash)
    to_hash == self.class.new(other_hash).to_hash
  end

  private

  def navigate value
    case value
    when Hash
      navigate_hash value
    when Array
      navigate_array value
    else
      navigate_value value
    end
  end

  def navigate_hash(value)
    self.class.new value
  end

  def navigate_array(value)
    value.map { |item| navigate item }
  end

  def navigate_value(value)
    value
  end

end
