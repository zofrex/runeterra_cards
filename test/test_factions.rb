# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards do
  cover 'RuneterraCards'
  # Paste table from Github ( https://github.com/RiotGames/LoRDeckCodes ) here:
  FACTION_TABLE = <<-TABLE
  0	DE	Demacia
  1	FR	Freljord
  2	IO	Ionia
  3	NX	Noxus
  4	PZ	Piltover & Zaun
  5	SI	Shadow Isles
  6	BW	Bilgewater
  9	MT	Mount Targon
  TABLE

  FACTIONS = FACTION_TABLE.split("\n").map(&:split).map{|line| [Integer(line[0], 10), line[1], line[2]]}.freeze

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
