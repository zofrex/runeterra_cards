<!-- This is the README file specifically for Github. It should only have an overview and cover development concerns. API docs and examples should go in the online documentation. -->

## Description

This library makes it easy to decode Legends of Runeterra deck codes, load Data Dragon metadata for cards, and perform operations on the data.

Deck code decoding is based on [the specification documented by Riot Games](https://github.com/RiotGames/LoRDeckCodes). Metadata loading is designed to work with the metadata from [Legends of Runeterra Data Dragon](https://developer.riotgames.com/docs/lor#data-dragon).

## Documentation

[Full API documentation including examples is available on Rubydoc](https://www.rubydoc.info/gems/runeterra_cards). It is recommended to read it there rather than reading the docs on Github.

## Installation

Add the following to your `Gemfile`:

```
gem 'runeterra_cards', '~> 0.6.0'
```

Or, if you're building a Gem, your `.gemspec`:

```
  spec.add_dependency 'runeterra_cards', '~> 0.6.0'
```

## Development & Contributing

Contributions are welcomed, but it's a good idea to file an issue first to make sure your change isn't in progress elsewhere. That said PRs are still welcome without an issue first.

If you want a first issue to work on, adding more fields to CardMetadata would be an easy place to start.

### Steps for developing:

* Check out the repository
* Install dependencies with Bundler
* Run `rake` as you work to run quick incremental checks (unit tests, coverage, style)
* Run `rake all_checks` before committing / pushing to run full checks

This library is fully unit tested with 100% coverage, as determined by mutation testing using [mutant](https://github.com/mbj/mutant). This tool isn't very common in the Ruby ecosystem so if you are struggling to get the mutant check to pass, feel free to make a PR with it failing and ask for help.