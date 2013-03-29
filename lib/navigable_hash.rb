require 'active_support/core_ext/hash'
require "active_support/hash_with_indifferent_access"

class NavigableHash < HashWithIndifferentAccess

  def initialize(constructor = {})
    super constructor.reduce({}) { |hash, (k, v)| hash.merge k => navigate(v) }
  end

  alias_method :get_value, :[]
  alias_method :set_value, :[]=

  def []=(key, value)
    set_value key, navigate(value)
  end

  def [](key)
    get_value key
  end

  def method_missing(m, *args, &block)
    if /(?<key>.+)=$/ =~ m && args.size == 1
      self.send :[]=, key, args.first
    elsif args.size == 0
      self.send :[], m
    else
      raise ArgumentError, "wrong number of arguments(#{args.size} for 0)"
    end
  end

  def respond_to?(m, include_private = false)
    true
  end

  def ==(other_hash)
    to_hash == self.class.new(other_hash).to_hash
  end

  private :get_value, :set_value

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
