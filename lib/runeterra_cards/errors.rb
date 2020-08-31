# frozen_string_literal: true

module RuneterraCards
  # The base exception for errors that occur when decoding a deck code
  class DeckCodeParseError < StandardError
  end

  # This exception is raised if the deck code cannot be Base32-decoded. This probably means it isn't a deck code, or
  # got malformed somehow.
  class Base32Error < DeckCodeParseError
    # Returns a new instance of Base32Error with a helpful error message preloaded.
    def initialize
      super('Encountered an error while Base32 decoding deck code.' \
        ' Probably an invalid deck code, or possibly a bug in the Base32 handling.')
    end
  end

  # This exception is raised if the deck code is an empty string.
  class EmptyInputError < DeckCodeParseError
    # Returns a new instance of EmptyInputError with a helpful error message preloaded.
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
    # @return [Fixnum] the version number encountered in the deck code
    attr_accessor :version

    # @param [Fixnum] expected The version number we were expecting to see in the deck code.
    # @param [Fixnum] got The version number we actually got.
    def initialize(expected, got)
      super("Unrecognized deck code version number: #{got}, was expecting: #{expected}. \
Possibly an invalid deck code, possibly you need to update the deck code library version.")
      @version = got
    end
  end

  # This exception is raised if the deck code contains an unexpected faction number. (see the table at
  # {https://github.com/RiotGames/LoRDeckCodes} for what 'faction number' means.) This most likely means that
  # Legends of Runeterra has a new faction and you need to update to a newer version of this library to handle it.
  #
  # Check that the {#faction_number} causing issues is listed in {https://github.com/RiotGames/LoRDeckCodes
  # the table on Github}. If it isn't then something else has gone wrong. If it is, and updating this library doesn't
  # fix the issue, then the library needs updating - {https://github.com/zofrex/runeterra_cards/issues file an issue}.
  class UnrecognizedFactionError < DeckCodeParseError
    # @return [Fixnum] the faction number that was unrecognized
    attr_reader :faction_number

    # @param [Fixnum] faction_number The faction number we encountered and did not recognise.
    def initialize(faction_number)
      super("Unrecognized faction number '#{faction_number}'."\
        ' Possibly you need to update this library to a newer version')
      @faction_number = faction_number
    end
  end

  # This exception is raised if you try to parse data from Runeterra Data Dragon that is not in the expected form.
  # The message will tell you what data was not right, and the {#card} attribute will tell you which card had issues,
  # if possible.
  #
  # @see CardMetadata#initialize CardMetadata#initialize for details on when this error is raised.
  class MetadataLoadError < StandardError
    # Return the name or card code of the card that was missing an expected attribute.
    # @return [String] name if the name was present
    # @return [String] card code if the name was not present
    # @return [nil] if neither name nor card code were present
    attr_reader :card

    # @param [String] card The card's name or cardCode.
    # @param [String] problem Details on the problem encountered loading the card.
    def initialize(card, problem)
      if card.nil?
        super("Error loading data for unknown card (no code or name): #{problem}")
      else
        super("Error loading data for card #{card}: #{problem}")
      end
      @card = card
    end

    # Create a {MetadataLoadError MetadataLoadError} with a helpful message regarding an invalid value for rarityRef.
    # @param [String] card The card name that had an invalid rarityRef value.
    #
    # @param [String] given The value that rarityRef had.
    # @param [Enumerable<String>] expected A list of values that would have been valid.
    # @return [MetadataLoadError]
    def self.invalid_rarity(card, given, expected)
      new(card, "Invalid value for rarityRef, got: #{given}, expected one of: #{expected.join ', '}")
    end
  end
end
