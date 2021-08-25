<!-- This is the README file for the Gem documentation / online documentation. It should be thorough and authoritative for using the Gem, but not discuss development concerns, which belong in the Github README. -->

## Description

This library makes it easy to decode Legends of Runeterra deck codes, load Data Dragon metadata for cards, and perform operations on the data.

## Installation

Add the following to your `Gemfile`:

```
gem 'runeterra_cards', '~> 0.6.0'
```

Or, if you're building a Gem, your `.gemspec`:

```
  spec.add_dependency 'runeterra_cards', '~> 0.6.0'
```

## Updates & Versioning

This library will conform to [semantic versioning](https://semver.org/) once it hits 1.0. In the meantime, you can rely on the minor version (Y in x.Y.z) being bumped for backwards-incompatible changes.

All changes are documented in the {file:doc/CHANGELOG.md}.

## Main Concepts

Your typical main entry points to this library will be {RuneterraCards::CardSet} for manipulating deck codes and/or {RuneterraCards::Metadata} for handling Data Dragon card data.

## Examples

Load a deck code:

```
require 'runeterra_cards'

deck_code = 'CEBAOAQGC4OSKJZJF44ACAQFBIBAIAQGAEPCYNIBAICQOAYCAECSOMADAIDAKGRWAEBAKAY'
deck = RuneterraCards::CardSet.from_deck_code(deck_code)

deck.count_for_card_code('02BW053') #=> 2

deck.cards.each do |card, count|
  puts "#{card} x#{count}"
end
```

Load metadata from Legends of Runeterra Data Dragon:

```
require 'runeterra_cards'

metadata = RuneterraCards::Metadata.new

metadata.add_set_file 'set1-en_us.json'
metadata.add_set_file 'set2-en_us.json'

card = metadata.lookup_card '02BW053'
card.name #=> "Nautilus"
```

## Development & Contributing

See the [Github project](https://github.com/zofrex/runeterra_cards) for more details.
