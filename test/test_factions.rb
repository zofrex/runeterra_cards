# frozen_string_literal: true

require_relative 'test_helper'

# Paste table from Github ( https://github.com/RiotGames/LoRDeckCodes ) here:
FACTION_TABLE = <<-TABLE
  1	0	DE	Demacia
  1	1	FR	Freljord
  1	2	IO	Ionia
  1	3	NX	Noxus
  1	4	PZ	Piltover & Zaun
  1	5	SI	Shadow Isles
  2	6	BW	Bilgewater
  2	9	MT	Mount Targon
  3	7	SH	Shurima
  4	10	BC	Bandle City
TABLE

FACTIONS = FACTION_TABLE.split("\n").map(&:split).map{|line| [Integer(line[1], 10), line[2], line[3]]}.freeze

describe RuneterraCards do
  cover 'RuneterraCards'

  describe 'FACTION_IDENTIFIERS_FROM_INT' do
    FACTIONS.each do |integer_identifier, faction_identifier, faction_name|
      it "#{faction_name}: integer identifier #{integer_identifier} => #{faction_identifier}" do
        _(RuneterraCards::FACTION_IDENTIFIERS_FROM_INT[integer_identifier]).must_equal faction_identifier
      end
    end
  end

  describe 'FACTION_INTS_FROM_IDENTIFIER' do
    FACTIONS.each do |integer_identifier, faction_identifier, faction_name|
      it "#{faction_name}: faction identifier #{faction_identifier} => #{integer_identifier}" do
        _(RuneterraCards::FACTION_INTS_FROM_IDENTIFIER[faction_identifier]).must_equal integer_identifier
      end
    end
  end
end
