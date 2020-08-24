# frozen_string_literal: true

module RuneterraCards
  # Represents a card and how many of that card are in a collection.
  class CardAndCount
    # The card code, for example "01DE123"
    # @return [String]
    attr_reader :code

    # How many of this card are in a collection (between 1-3).
    # @return [Fixnum]
    attr_reader :count

    # @param set_number [Fixnum]
    # @param faction_number [Fixnum]
    # @param card_number [Fixnum]
    # @param count [Fixnum]
    def initialize(set_number, faction_number, card_number, count)
      padded_set = format('%<i>02d', i: set_number)
      faction = RuneterraCards::FACTION_IDENTIFIERS_FROM_INT[faction_number]
      padded_card_number = format('%<i>03d', i: card_number)
      @code = "#{padded_set}#{faction}#{padded_card_number}"
      @count = count
    end

    def eql?(other)
      @code == other.code &&
        @count == other.count
    end

    def hash
      [@code, @count].hash
    end
  end
end
