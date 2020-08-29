# frozen_string_literal: true

module RuneterraCards
  # Represents a card and how many of that card are in a collection.
  # @deprecated
  class CardAndCount
    # The card code, for example "01DE123"
    # @return [String]
    attr_reader :code

    # How many of this card are in a collection (between 1-3).
    # @return [Fixnum]
    attr_reader :count

    # @param set [Fixnum]
    # @param faction_number [Fixnum]
    # @param card_number [Fixnum]
    # @param count [Fixnum]
    def initialize(code: nil, count:, set: nil, faction_number: nil, card_number: nil)
      if code
        raise if set || faction_number || card_number

        @code = code
      else
        padded_set = format('%<i>02d', i: set)
        faction = FACTION_IDENTIFIERS_FROM_INT.fetch(faction_number) { |key| raise UnrecognizedFactionError, key }
        padded_card_number = format('%<i>03d', i: card_number)
        @code = "#{padded_set}#{faction}#{padded_card_number}"
      end
      @count = count
    end

    def eql?(other)
      code.eql?(other.code) && count.equal?(other.count)
    end

    def hash
      [code, count].hash
    end
  end
end
