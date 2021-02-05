# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.1] - 2021-02-05

Fixed

- Fixed issue where card numbers > 127 came out extremely wrong, e.g. Aphelios and several other of the new cards ([issue #4](https://github.com/zofrex/runeterra_cards/issues/4))
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
