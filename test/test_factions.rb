# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards do
  # Paste table from Github ( https://github.com/RiotGames/LoRDeckCodes ) here:
  FACTION_TABLE = <<-TABLE
  0	DE	Demacia
  1	FR	Freljord
  2	IO	Ionia
  3	NX	Noxus
  4	PZ	Piltover & Zaun
  5	SI	Shadow Isles
  6	BW	Bilgewater
  TABLE

  FACTIONS = FACTION_TABLE.split("\n").map { |line| line.split[1] }.freeze

  describe 'FACTION_IDENTIFIERS_FROM_INT' do
    FACTIONS.each_with_index do |faction, index|
      it "has #{faction} at position #{index}" do
        _(RuneterraCards::FACTION_IDENTIFIERS_FROM_INT[index]).must_equal faction
      end
    end
  end

  describe 'FACTION_INTS_FROM_IDENTIFIER' do
    FACTIONS.each_with_index do |faction, index|
      it "gives #{index} when looking up '#{faction}'" do
        _(RuneterraCards::FACTION_INTS_FROM_IDENTIFIER[faction]).must_equal index
      end
    end
  end
end
