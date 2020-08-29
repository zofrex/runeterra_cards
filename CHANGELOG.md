# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- UnrecognizedVersionError#version returns the version number that wasn't recognized.
- UnrecognizedFactionError, which is raised by CardAndCount#new (and by extension, CardSet#from_deck_code) if an unrecognized faction number is encountered.

## [0.1.0] - 2020-08-28
### Added
- Initial public release, with support for loading deck codes (Bilgewater and earlier) and loading metadata from Legends of Runeterra Data Dragon.
