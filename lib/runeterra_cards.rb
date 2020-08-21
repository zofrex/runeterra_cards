# frozen_string_literal: true

require 'runeterra_cards/version'
require 'runeterra_cards/errors'
require 'runeterra_cards/factions'
require 'runeterra_cards/card_and_count'
require 'runeterra_cards/card_metadata'
require 'runeterra_cards/metadata'

require 'base32'

# Represents a collection of cards.
#
# A collection of cards is technically a collection of {CardAndCount}. Each object represents a card and how many of
# that card are in the collection, rather than having duplicate objects in the collection to represent duplicate cards.
# @todo put this on the card collection class rather than the module
module RuneterraCards
  # The version of deck encoding supported
  SUPPORTED_VERSION = 1

  # @param deck_code [String]
  # @raise [Base32Error] if the deck code cannot be Base32 decoded.
  # @raise [UnrecognizedVersionError] if the deck code's version is not supported by this library
  #   (see {SUPPORTED_VERSION}).
  # @raise [EmptyInputError] if the deck code is an empty string.
  def self.from_deck_code(deck_code)
    raise EmptyInputError if deck_code.empty?

    begin
      bin = Base32.decode(deck_code)
    rescue StandardError
      raise Base32Error
    end

    format_and_version = bin[0].unpack1('C')
    #   format = format_and_version >> 4
    version = format_and_version & 0xF

    raise UnrecognizedVersionError.new(SUPPORTED_VERSION, version) if version != SUPPORTED_VERSION
  end
end
