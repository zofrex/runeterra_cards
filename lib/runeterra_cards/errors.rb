module RuneterraCards
  class DeckCodeParseError < StandardError; end

  class Base32Error < DeckCodeParseError
    def initialize
      super("Encountered an error while Base32 decoding deck code. Probably an invalid deck code, or possibly a bug in the Base32 handling.")
    end
  end
end