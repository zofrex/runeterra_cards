# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::CardSet do
  describe 'smoke tests from upstream' do
    tests =
      File.open(File.join(__dir__, 'data', 'upstream-tests', 'DeckCodesTestData.txt')) do |test_data_file|
        test_data_file.each_line.map(&:strip).chunk_while {|_, j| !j.empty?}.map { |test| test.reject(&:empty?)}
      end

    raise if tests.empty?

    tests.each do |test_data|
      deck_code = test_data.shift
      raise if deck_code.strip.empty?

      it "test deck code #{deck_code.inspect}" do
        # require 'pry'; binding.pry
        deck = RuneterraCards::CardSet.from_deck_code(deck_code)

        expected = {}
        test_data.each do |card|
          count, code = card.split(':')
          expected[RuneterraCards::Card.new(code: code)] = Integer(count, 10)
        end

        _(deck.as_cards).must_equal expected
      end
    end
  end

  # Manually created by hand from a rando online deck - https://lor.mobalytics.gg/decks/bt427nlbunq3k45dg87g
  it 'can pass a Targon deck smoke test' do
    deck_code = 'CEBAKAIEAENR6JBUAQBQSIZJKZQAGAQBAQTS2AQDBEKVKAIDAQIQEAQBAQGDUAIDBEZQ'

    expected = {
      RuneterraCards::Card.new(code: '01PZ036') => 3, # ezreal
      RuneterraCards::Card.new(code: '03MT086') => 3, # spacey sketcher
      RuneterraCards::Card.new(code: '01PZ045') => 2, # zaunite urchin
      RuneterraCards::Card.new(code: '01PZ012') => 1, # flame chompers
      RuneterraCards::Card.new(code: '03MT041') => 3, # mentor of the stones
      RuneterraCards::Card.new(code: '03MT096') => 3, # solari priestess
      RuneterraCards::Card.new(code: '01PZ058') => 1, # chump wump
      RuneterraCards::Card.new(code: '03MT021') => 2, # infinite mindsplitter
      RuneterraCards::Card.new(code: '01PZ027') => 3, # thermogenic beam
      RuneterraCards::Card.new(code: '01PZ001') => 3, # rummage
      RuneterraCards::Card.new(code: '03MT051') => 1, # guiding touch
      RuneterraCards::Card.new(code: '01PZ052') => 3, # mystic shot
      RuneterraCards::Card.new(code: '03MT035') => 3, # pale cascade
      RuneterraCards::Card.new(code: '01PZ039') => 2, # get excited!
      RuneterraCards::Card.new(code: '03MT085') => 2, # hush
      RuneterraCards::Card.new(code: '01PZ031') => 3, # statikk shock
      RuneterraCards::Card.new(code: '03PZ017') => 2, # tri-beam improbulator
    }

    deck = RuneterraCards::CardSet.from_deck_code(deck_code)

    _(deck.as_cards).must_equal expected
  end

  # From a rando online deck - https://lor.mobalytics.gg/decks/c0vsfp4b5t283avdiq5g
  it 'can load Shurima cards' do
    deck_code = 'CEBQKBAHAEGRUSKZAQCACAIFAYHAEAIBCQZACAYEA4PUY6IBAECAOOY'

    deck = RuneterraCards::CardSet.from_deck_code(deck_code) # doesn't throw exception

    _(deck.count_for_card_code('04SH073')).must_equal 3
  end

  # Made a deck containing one bandle card
  it 'can load Bandle City decks' do
    deck_code = 'CQAAAAIBAUFKAAI'

    deck = RuneterraCards::CardSet.from_deck_code(deck_code) # doesn't throw exception

    _(deck.count_for_card_code('05BC160')).must_equal 1
  end
end
