# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::CardAndCount do
  cover 'RuneterraCards::CardAndCount'
  describe 'initialise from integers' do
    it 'pads the set' do
      card = RuneterraCards::CardAndCount.new(set: 2, faction_number: 1, card_number: 1, count: 1)
      _(card.code).must_match(/^02/)
    end

    it 'looks up the faction identifier' do
      card = RuneterraCards::CardAndCount.new(set: 2, faction_number: 6, card_number: 1, count: 1)
      _(card.code).must_match(/BW/)
    end

    it 'pads the card number' do
      card = RuneterraCards::CardAndCount.new(set: 2, faction_number: 6, card_number: 37, count: 1)
      _(card.code).must_match(/037$/)
    end

    it 'matches exactly a whole card' do
      card = RuneterraCards::CardAndCount.new(set: 1, faction_number: 0, card_number: 123, count: 1)
      _(card.code).must_equal('01DE123')
    end

    it 'sets the count' do
      card = RuneterraCards::CardAndCount.new(set: 1, faction_number: 0, card_number: 2, count: 3)
      _(card.count).must_equal(3)
    end
  end

  describe 'initialise from card code' do
    it 'sets the code' do
      card = RuneterraCards::CardAndCount.new(code: '01DE123', count: 2)
      _(card.code).must_equal('01DE123')
    end

    it 'sets the count' do
      card = RuneterraCards::CardAndCount.new(code: '01DE123', count: 2)
      _(card.count).must_equal(2)
    end
  end

  describe 'provide integers xor card code' do # TODO: make these errors more specific? investigate
    it 'errors if you set code and set number' do
      _{RuneterraCards::CardAndCount.new(count: 1, code: 'foo', set: 0)}.must_raise StandardError
    end

    it 'errors if you set code and faction' do
      _{RuneterraCards::CardAndCount.new(count: 1, code: 'foo', faction_number: 0)}.must_raise StandardError
    end

    it 'errors if you set code and card number' do
      _{RuneterraCards::CardAndCount.new(count: 1, code: 'foo', card_number: 0)}.must_raise StandardError
    end

    it 'errors if you provide neither code nor any integers' do
      _{RuneterraCards::CardAndCount.new(count: 1)}.must_raise StandardError
    end

    it 'errors if you omit set' do
      _{RuneterraCards::CardAndCount.new(count: 1, faction_number: 0, card_number: 0)}.must_raise StandardError
    end

    it 'errors if you omit faction' do
      _{RuneterraCards::CardAndCount.new(count: 1, set: 0, card_number: 0)}.must_raise StandardError
    end

    it 'errors if you omit card number' do
      _{RuneterraCards::CardAndCount.new(count: 1, set: 0, faction_number: 0)}.must_raise StandardError
    end
  end

  describe '#eql?' do
    it 'returns true if code AND count are the same' do
      card1 = RuneterraCards::CardAndCount.new(set: 1, faction_number: 0, card_number: 2, count: 3)
      card2 = RuneterraCards::CardAndCount.new(set: 1, faction_number: 0, card_number: 2, count: 3)
      _(card1.eql?(card2)).must_equal true
    end

    it 'returns false if code differs and count is the same' do
      card1 = RuneterraCards::CardAndCount.new(set: 1, faction_number: 0, card_number: 2, count: 3)
      card2 = RuneterraCards::CardAndCount.new(set: 1, faction_number: 0, card_number: 3, count: 3)
      _(card1.eql?(card2)).must_equal false
    end

    it 'returns false if code is the same and count differs' do
      card1 = RuneterraCards::CardAndCount.new(set: 1, faction_number: 0, card_number: 2, count: 3)
      card2 = RuneterraCards::CardAndCount.new(set: 1, faction_number: 0, card_number: 2, count: 2)
      _(card1.eql?(card2)).must_equal false
    end
  end

  describe '#hash' do
    it 'is the same for two identical objects' do
      card1 = RuneterraCards::CardAndCount.new(code: '01DE044', count: 3)
      card2 = RuneterraCards::CardAndCount.new(code: '01DE044', count: 3)
      _(card1.hash).must_equal card2.hash
    end

    it 'is different for objects that differ only by count' do
      card1 = RuneterraCards::CardAndCount.new(code: '01DE044', count: 3)
      card2 = RuneterraCards::CardAndCount.new(code: '01DE044', count: 2)
      _(card1.hash).wont_equal card2.hash
    end

    it 'is different for objects that differ only by code' do
      card1 = RuneterraCards::CardAndCount.new(code: '01DE044', count: 3)
      card2 = RuneterraCards::CardAndCount.new(code: '01DE043', count: 3)
      _(card1.hash).wont_equal card2.hash
    end

    it 'allows CardAndCount to be placed in a Set' do
      card = RuneterraCards::CardAndCount.new(code: '01DE044', count: 3)
      Set[card] # won't raise
    end
  end
end
