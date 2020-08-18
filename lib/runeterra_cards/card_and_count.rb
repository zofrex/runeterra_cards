# frozen_string_literal: true

module RuneterraCards
  class CardAndCount
    attr_reader :code, :count

    def initialize(set_number, faction_number, card_number, count)
      padded_set = format('%<i>02d', i: set_number)
      faction = RuneterraCards::FACTION_IDENTIFIERS_FROM_INT[faction_number]
      padded_card_number = format('%<i>03d', i: card_number)
      @code = "#{padded_set}#{faction}#{padded_card_number}"
      @count = count
    end
  end
end
