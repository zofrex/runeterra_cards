# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.0] - 2022-05-26
### Added

- Support for the Runeterra faction.
- Support for version 5 deck codes.

## [0.6.1] - 2022-04-30
### Added

- Documented which versions of Ruby are officially supported:
  - Ruby: 2.6, 2.7, 3.0, 3.1
  - JRuby: 9.3
  - TruffleRuby: 20, 21, 22

### Fixed

- Various scenarios where invalid deck codes would produce unhelpful exceptions now raise a `DeckCodeParseError` instead.

## [0.6.0] - 2021-08-25
### Added
- Support for the Bandle City faction.
- Support for version 4 deck codes.

## [0.5.0] - 2021-03-05
### Added
- Support for the Shurima faction.
- Support for version 3 deck codes.
- A new Card class to represent cards on their own without a count.
- CardSet#as_cards, which returns all the cards in the set as Cards.
- CardSet#as_card_codes, which returns all the cards in the set as card codes.

### Removed
- RuneterraCards.from_card_and_counts method.
- CardAndCount class (replaced by the new Card class).
- CardSet#as_card_and_counts (replaced by #as_cards).

### Deprecated
- CardSet#cards – the signature of this method will be changing in a future version to match #as_cards, migrate to #as_card_codes to keep the current #cards behaviour.

## [0.4.1] - 2021-02-05
### Fixed

- Fixed issue where card numbers > 127 came out extremely wrong, e.g. Aphelios and several other of the new cards ([issue #4](https://github.com/zofrex/runeterra_cards/issues/4)).

## [0.4.0] - 2020-12-08
### Added
- [`CardMetadata` now has a `#cost` attribute representing the mana cost of a card.](https://github.com/zofrex/runeterra_cards/pull/3) (thanks, [nieszkah](https://github.com/alpm)!) Technically this is backwards-compatibility breaking as it makes a new field in metadata json mandatory.

## [0.3.0] - 2020-08-31
### Added
- `Cost` class to represent crafting cost as wildcards & shards.
- `Metadata#cost_of` to get the cost of crafting a `CardSet`.
- Documented everything that is public & non-deprecated.

## [0.2.3] - 2020-08-31
### Fixed
- Fixed issue with documentation not rendering on rubydoc.info.

## [0.2.2] - 2020-08-30
### Fixed
- Included .yardopts in the Gem so README and CHANGELOG get included in documentation generated from the Gem.

## [0.2.1] - 2020-08-29
### Fixed
- Correctly packaged README and CHANGELOG in the Gem.

## [0.2.0] - 2020-08-29
### Added
- Added support for the Mount Targon faction
- UnrecognizedVersionError#version returns the version number that wasn't recognized.
- UnrecognizedFactionError, which is raised by CardAndCount#new (and by extension, CardSet#from_deck_code) if an unrecognized faction number is encountered.

### Changed
- FACTION_IDENTIFIERS_FROM_INT is now a Hash instead of an Array. The API for looking up a faction identifier by integer should remain unchanged in most cases.

## [0.1.0] - 2020-08-28
### Added
- Initial public release, with support for loading deck codes (Bilgewater and earlier) and loading metadata from Legends of Runeterra Data Dragon.
