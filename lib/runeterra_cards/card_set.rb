# frozen_string_literal: true

require 'base32'

module RuneterraCards
  # Represents a collection of cards.
  #
  # A collection of cards is technically a collection of {CardAndCount}. Each object represents a card and how many of
  # that card are in the collection, rather than having duplicate objects in the collection to represent duplicate
  # cards.
  class CardSet
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
end
