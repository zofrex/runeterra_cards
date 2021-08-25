# frozen_string_literal: true

module RuneterraCards
  # Represents a card.
  #
  # @todo: add getters for set, faction, card number
  class Card
    # The card code, for example "01DE123"
    # @return [String]
    attr_reader :code

    # @param set [Fixnum]
    # @param faction_number [Fixnum]
    # @param card_number [Fixnum]
    def initialize(code: nil, set: nil, faction_number: nil, card_number: nil)
      if code
        raise if set || faction_number || card_number

        @code = code
      else
        padded_set = format('%<i>02d', i: set)
        faction = FACTION_IDENTIFIERS_FROM_INT.fetch(faction_number) { |key| raise UnrecognizedFactionError, key }
        padded_card_number = format('%<i>03d', i: card_number)
        @code = "#{padded_set}#{faction}#{padded_card_number}"
      end
    end

    # Returns +true+ if _this_ and _other_ both have the same card code.
    #
    # @param other [Card]
    # @return [Boolean]
    def eql?(other)
      code.eql?(other.code)
    end

    # Compute a hash code for this card. Two cards with the same card code will have the same hash code (and will
    # compare using {#eql?}).
    #
    # @see Object#hash.
    # @return [Integer]
    def hash
      code.hash
    end
  end
end
