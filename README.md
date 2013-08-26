# NavigableHash

[![Version](http://allthebadges.io/jwaldrip/navigable_hash/badge_fury.png)](http://allthebadges.io/jwaldrip/navigable_hash/badge_fury)
[![Dependencies](http://allthebadges.io/jwaldrip/navigable_hash/gemnasium.png)](http://allthebadges.io/jwaldrip/navigable_hash/gemnasium)
[![Build Status](http://allthebadges.io/jwaldrip/navigable_hash/travis.png)](http://allthebadges.io/jwaldrip/navigable_hash/travis)
[![Coverage](http://allthebadges.io/jwaldrip/navigable_hash/coveralls.png)](http://allthebadges.io/jwaldrip/navigable_hash/coveralls)
[![Code Climate](http://allthebadges.io/jwaldrip/navigable_hash/code_climate.png)](http://allthebadges.io/jwaldrip/navigable_hash/code_climate)

NavigableHash was built as lightweight and quick way to navigate through a hash or array object using the familiar ruby dot notation.  See 'Usage' below for examples.  Keys as strings or symbols don't matter, its all included.

## Installation

Add this line to your application's Gemfile:

    gem 'navigable_hash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install navigable_hash

## Usage

(Check out the rspec tests for coverage examples)

Most basic usage:
```ruby
test_hash = { :example_key => 'example value' }
navigable_hash = NavigableHash.new(test_hash)

navigable_hash.example_key
# => 'example_value'
```


More:
```ruby
new_hash = { :second_key => { :inner_key => true }, :array_item => [{}, "string", :symbol] }
navigable_hash = NavigableHash.new(new_hash)

navigable_hash.second_key.inner_key
# => true

navigable_hash.array_item.last
# => :symbol
```


Call Agnostic (key as a string, symbol or dot notation):
```ruby
new_hash = { "first_key" => "value 1" }
navigable_hash = NavigableHash.new(new_hash)

navigable_hash.first_key
navigable_hash[:first_key]
navigable_hash["first_key"]
# => "value 1"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
