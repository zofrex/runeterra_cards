# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::CardAndCount do
  it 'pads the set' do
    card = RuneterraCards::CardAndCount.new(2, 1, 1, 1)
    _(card.code).must_match(/^02/)
  end

  it 'looks up the faction identifier' do
    card = RuneterraCards::CardAndCount.new(2, 6, 1, 1)
    _(card.code).must_match(/BW/)
  end

  it 'pads the card number' do
    card = RuneterraCards::CardAndCount.new(2, 6, 37, 1)
    _(card.code).must_match(/037$/)
  end

  it 'matches exactly a whole card' do
    card = RuneterraCards::CardAndCount.new(1, 0, 123, 1)
    _(card.code).must_equal('01DE123')
  end

  it 'sets the count' do
    card = RuneterraCards::CardAndCount.new(1, 0, 2, 3)
    _(card.count).must_equal(3)
  end

  describe '#eql?' do
    it 'returns true if code AND count are the same' do
      card1 = RuneterraCards::CardAndCount.new(1, 0, 2, 3)
      card2 = RuneterraCards::CardAndCount.new(1, 0, 2, 3)
      _(card1.eql?(card2)).must_equal true
    end

    it 'returns false if code differs and count is the same' do
      card1 = RuneterraCards::CardAndCount.new(1, 0, 2, 3)
      card2 = RuneterraCards::CardAndCount.new(1, 0, 3, 3)
      _(card1.eql?(card2)).must_equal false
    end

    it 'returns false if code is the same and count differs' do
      card1 = RuneterraCards::CardAndCount.new(1, 0, 2, 3)
      card2 = RuneterraCards::CardAndCount.new(1, 0, 2, 2)
      _(card1.eql?(card2)).must_equal false
    end
  end
end
