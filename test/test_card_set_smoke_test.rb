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
          expected << RuneterraCards::CardAndCount.new(code: code, count: count.to_i)
        end

        _(deck.as_card_and_counts.to_set).must_equal expected
      end
    end
  end
end
