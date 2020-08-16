module RuneterraCards
  class DeckCodeParseError < StandardError; end

  class Base32Error < DeckCodeParseError
    def initialize
      super("Encountered an error while Base32 decoding deck code. Probably an invalid deck code, or possibly a bug in the Base32 handling.")
    end
  end

  class EmptyInputError < DeckCodeParseError
    def initialize
      super("The input was an empty string")
    end
  end

  class UnrecognizedVersionError < DeckCodeParseError
    def initialize(expected, got)
      super("Unrecognized deck code version number: #{got}, was expecting: #{expected}. Possibly an invalid deck code, possibly you need to update the deck code library version.")
    end
  end
end
