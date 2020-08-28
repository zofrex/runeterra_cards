# frozen_string_literal: true

module RuneterraCards
  # The base exception for errors that occur when decoding a deck code
  class DeckCodeParseError < StandardError
  end

  # This exception is raised if the deck code cannot be Base32-decoded. This probably means it isn't a deck code, or
  # got malformed somehow.
  class Base32Error < DeckCodeParseError
    def initialize
      super('Encountered an error while Base32 decoding deck code.' \
        ' Probably an invalid deck code, or possibly a bug in the Base32 handling.')
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

  # This exception is raised if you try to parse data from Runeterra Data Dragon that is not in the expected form.
  # The message will tell you what data was not right, and the {#card} attribute will tell you which card had issues,
  # if possible.
  #
  # @see CardMetadata#initialize
  class MetadataLoadError < StandardError
    # Return the name or card code of the card that was missing an expected attribute.
    # @return [String] name if the name was present
    # @return [String] card code if the name was not present
    # @return [nil] if neither name nor card code were present
    attr_reader :card

    def initialize(card, problem)
      if card.nil?
        super("Error loading data for unknown card (no code or name): #{problem}")
      else
        super("Error loading data for card #{card}: #{problem}")
      end
      @card = card
    end
  end
end
