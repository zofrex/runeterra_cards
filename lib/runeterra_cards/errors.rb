# frozen_string_literal: true

module RuneterraCards
  # The base exception for errors that occur when decoding a deck code
  class DeckCodeParseError < StandardError
  end

  # This exception is raised if the deck code cannot be Base32-decoded. This probably means it isn't a deck code, or
  # got malformed somehow.
  class Base32Error < DeckCodeParseError
    def initialize
      super('Encountered an error while Base32 decoding deck code. \
Probably an invalid deck code, or possibly a bug in the Base32 handling.')
    end
  end

  # This exception is raised if the deck code is an empty string.
  class EmptyInputError < DeckCodeParseError
    def initialize
      super('The input was an empty string')
    end
  end

  # This exception is raised if the deck code version number in the deck code is not one we can handle. This could mean
  # this isn't a deck code (especially if the version number is very different to the one expected), or it could mean
  # Riot has updated the deck code version and you need to update this library.
  #
  # If updating this library fails to resolve the issue, and  you are sure this is a deck code, check GitHub for an
  # issue relating to this. If none exists, then file one!
  # @see SUPPORTED_VERSION
  class UnrecognizedVersionError < DeckCodeParseError
    def initialize(expected, got)
      super("Unrecognized deck code version number: #{got}, was expecting: #{expected}. \
Possibly an invalid deck code, possibly you need to update the deck code library version.")
    end
  end

  # This exception is raised if you try to parse card data that is missing expected attributes.
  #
  # @see CardMetadata#initialize
  class MissingCardDataError < StandardError
    # Return the name of the expected key that was missing from the hash.
    # NB: If multiple keys were missing, this will only tell you about the first that was encountered.
    # @return [String]
    attr_reader :missing_key

    # Return the name or card code of the card that was missing an expected attribute.
    # @return [String] name if the name was present
    # @return [String] card code if the name was not present
    # @return [nil] if neither name nor card code were present
    attr_reader :card

    def initialize(missing_key, card=nil)
      if card.nil?
        super("Card data was missing required key #{missing_key}")
      else
        super("Card #{card} was missing required key #{missing_key}")
      end
      @missing_key, @card = missing_key, card
    end
  end
end
