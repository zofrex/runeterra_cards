# frozen_string_literal: true

require 'base32'

module RuneterraCards
  # Represents a collection of cards.
  #
  # @todo The API to this class is very unstable and will change a lot in a coming release.
  # @todo add #== !
  class CardSet
    # Extract this bitmask so Mutant can't see it, until this fix is released https://github.com/mbj/mutant/pull/1218
    HIGH_BIT = 0b1000_0000
    private_constant :HIGH_BIT

    # @return [Hash{String => Number}]
    # @deprecated
    attr_reader :cards

    # @param [Hash{String => Number},Enumerable{String => Number}] cards A Hash of card codes mapping to card counts
    def initialize(cards)
      @cards = cards
    end

    # Subtract another {CardSet CardSet} from this one. Items with count 0 are not represented in the returned
    # {CardSet CardSet}, they are removed altogether.
    # @param [CardSet] other An object that responds to {#count_for_card_code}
    # @return [CardSet]
    def -(other)
      remaining_cards =
        cards.each_with_object({}) do |(code, count), result|
          new_count = count - other.count_for_card_code(code)
          result[code] = new_count unless new_count.eql?(0)
        end

      CardSet.new(remaining_cards)
    end

    # @return [Enumerable<Card => Number>]
    def as_cards
      cards.transform_keys { |code| Card.new(code: code) }
    end

    # Return all cards in the card set as a map of card codes to counts.
    # @example
    #   set.as_card_codes #=> { '01DE044' => 1, '02NX003' => 2 }
    # @return [Enumerable<String => Number>]
    def as_card_codes
      cards
    end

    # Returns how many of the given card are in this CardSet.
    # @param [String] code Card code, e.g. "01DE031"
    # @return [Integer] How many of the card are in this CardSet, or 0 if it isn't present.
    def count_for_card_code(code)
      cards[code] || 0
    end

    # Parse a Deck Code.
    # @param deck_code [String]
    # @raise [Base32Error] if the deck code cannot be Base32 decoded.
    # @raise [UnrecognizedVersionError] if the deck code's version is not supported by this library
    #   (see {SUPPORTED_VERSION}).
    # @raise [EmptyInputError] if the deck code is an empty string.
    # @return [CardSet]
    def self.from_deck_code(deck_code)
      binary_data = decode_base32(deck_code)
      format, version = decode_format_and_version(binary_data[0])

      raise UnrecognizedVersionError.new(SUPPORTED_VERSION, version) unless version <= SUPPORTED_VERSION

      raise unless format.eql? 1

      int_array = unpack_big_endian_varint(binary_data[1..])
      cards = assemble_card_list(int_array)

      new(cards.to_h)
    end

    # @param string [String] base32-encoded string
    # @return [String] binary data
    def self.decode_base32(string)
      raise EmptyInputError if string.empty?

      begin
        Base32.decode(string)
      rescue StandardError
        raise Base32Error
      end
    end

    private_class_method :decode_base32

    # @param byte [String] a single byte
    # @return [FixNum] format and version, in that order
    def self.decode_format_and_version(byte)
      format_and_version = byte.unpack1('C')
      format = format_and_version >> 4
      version = format_and_version & 0xF
      [format, version]
    end

    private_class_method :decode_format_and_version

    # @param [Array<Fixnum>] array
    # @return [Array<Card>]
    def self.assemble_card_list(array)
      3.downto(1).flat_map do |number_of_copies|
        set_faction_combination_count = shift_and_check(array)
        set_faction_combination_count.times.flat_map do
          number_of_cards, set, faction = shift_and_check(array, 3)

          shift_and_check(array, number_of_cards).map do |card_number|
            cac = Card.new(set: set, faction_number: faction, card_number: card_number)
            [cac.code, number_of_copies]
          end
        end
      end
    end

    private_class_method :assemble_card_list

    # Like Array#shift but checks that the number of items requested was
    #   actually retrieved, errors otherwise.
    # @param [Array<T>] array Array to shift one or more values from
    # @param [Integer] count Number of items to shift from the array (default 1)
    # @return [Array<T>,T]
    # @raise [DeckCodeParseError]
    def self.shift_and_check(array, count=nil)
      if count
        raise DeckCodeParseError if array.length < count

        array.shift(count)
      else
        raise DeckCodeParseError if array.empty?

        array.shift
      end
    end

    private_class_method :shift_and_check

    # @param [String] binary
    # @return [Enumerable<Fixnum>]
    def self.unpack_big_endian_varint(binary)
      binary.each_byte.slice_after { |b| (b & HIGH_BIT).zero? }.map do |int_bytes|
        acc = 0
        int_bytes.each_with_index do |byte, index|
          acc += (byte & 0b0111_1111) << (7 * index)
        end
        acc
      end
    end

    private_class_method :unpack_big_endian_varint
  end
end
