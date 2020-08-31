# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::CardSet do
  describe 'smoke tests from upstream' do
    test_data_file = File.read(File.join(__dir__, 'data', 'upstream-tests', 'DeckCodesTestData.txt'))
    tests = test_data_file.split("\n").chunk_while {|_, j| !j.empty?}.map { |test| test.reject(&:empty?)}

    tests.each do |test_data|
      deck_code = test_data.shift

      it "test deck code #{deck_code}" do
        # require 'pry'; binding.pry
        deck = RuneterraCards::CardSet.from_deck_code(deck_code)

        expected = Set[]
        test_data.each do |card|
          count, code = card.split(':')
          expected << RuneterraCards::CardAndCount.new(code: code, count: Integer(count, 10))
        end

        _(deck.as_card_and_counts.to_set).must_equal expected
      end
    end
  end

  # Manually created by hand from a rando online deck - https://lor.mobalytics.gg/decks/bt427nlbunq3k45dg87g
  it 'can pass a Targon deck smoke test' do
    deck_code = 'CEBAKAIEAENR6JBUAQBQSIZJKZQAGAQBAQTS2AQDBEKVKAIDAQIQEAQBAQGDUAIDBEZQ'

    expected = Set[
        RuneterraCards::CardAndCount.new(code: '01PZ036', count: 3), # ezreal
        RuneterraCards::CardAndCount.new(code: '03MT086', count: 3), # spacey sketcher
        RuneterraCards::CardAndCount.new(code: '01PZ045', count: 2), # zaunite urchin
        RuneterraCards::CardAndCount.new(code: '01PZ012', count: 1), # flame chompers
        RuneterraCards::CardAndCount.new(code: '03MT041', count: 3), # mentor of the stones
        RuneterraCards::CardAndCount.new(code: '03MT096', count: 3), # solari priestess
        RuneterraCards::CardAndCount.new(code: '01PZ058', count: 1), # chump wump
        RuneterraCards::CardAndCount.new(code: '03MT021', count: 2), # infinite mindsplitter
        RuneterraCards::CardAndCount.new(code: '01PZ027', count: 3), # thermogenic beam
        RuneterraCards::CardAndCount.new(code: '01PZ001', count: 3), # rummage
        RuneterraCards::CardAndCount.new(code: '03MT051', count: 1), # guiding touch
        RuneterraCards::CardAndCount.new(code: '01PZ052', count: 3), # mystic shot
        RuneterraCards::CardAndCount.new(code: '03MT035', count: 3), # pale cascade
        RuneterraCards::CardAndCount.new(code: '01PZ039', count: 2), # get excited!
        RuneterraCards::CardAndCount.new(code: '03MT085', count: 2), # hush
        RuneterraCards::CardAndCount.new(code: '01PZ031', count: 3), # statikk shock
        RuneterraCards::CardAndCount.new(code: '03PZ017', count: 2), # tri-beam improbulator
    ]

    deck = RuneterraCards::CardSet.from_deck_code(deck_code)

    _(deck.as_card_and_counts.to_set).must_equal expected
  end
end
