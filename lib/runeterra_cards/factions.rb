# frozen_string_literal: true

module RuneterraCards
  # Paste table from Github ( https://github.com/RiotGames/LoRDeckCodes ) here:
  FACTION_MAPPING_TABLE = <<-TABLE
  0	DE	Demacia
  1	FR	Freljord
  2	IO	Ionia
  3	NX	Noxus
  4	PZ	Piltover & Zaun
  5	SI	Shadow Isles
  6	BW	Bilgewater
  TABLE

  # An array of the two-letter Faction identifiers, indexed by their integer identifiers
  # @example
  #   FACTION_IDENTIFIERS_FROM_INT[2] #=> "IO"
  # @return [Array<String>]
  FACTION_IDENTIFIERS_FROM_INT = RuneterraCards::FACTION_MAPPING_TABLE.split("\n").map { |line| line.split[1] }.freeze

  # A map from two-letter Faction identifiers to their integer identifiers
  # @example
  #   FACTION_INTS_FROM_IDENTIFIER["IO"] #=> 2
  # @return [Hash<String,Fixnum>]
  FACTION_INTS_FROM_IDENTIFIER = Hash[FACTION_IDENTIFIERS_FROM_INT.each_with_index
                                                                  .map { |faction, index| [faction, index] }].freeze
  private_constant :FACTION_MAPPING_TABLE
end
