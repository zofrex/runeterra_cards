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

  FACTION_IDENTIFIERS_FROM_INT = RuneterraCards::FACTION_MAPPING_TABLE.split("\n").map{|line| line.split[1]}
  FACTION_INTS_FROM_IDENTIFIER = Hash[FACTION_IDENTIFIERS_FROM_INT.each_with_index.map {|faction,index| [faction,index]}]
  private_constant :FACTION_MAPPING_TABLE
end
