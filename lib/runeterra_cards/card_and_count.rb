module RuneterraCards
  class CardAndCount
    attr_reader :code, :count

    def initialize(set_number, faction_number, card_number, count)
      padded_set = format('%02d', set_number)
      faction = RuneterraCards::FACTION_IDENTIFIERS_FROM_INT[faction_number]
      padded_card_number = format('%03d', card_number)
      @code = "#{padded_set}#{faction}#{padded_card_number}"
      @count = count
    end
  end
end
