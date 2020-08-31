# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::Cost do
  cover 'RuneterraCards::Cost'

  describe 'set and retrieve wildcard counts' do
    it 'has common cards' do
      _(RuneterraCards::Cost.new(0, 0, 0, 0).common).must_equal(0)
      _(RuneterraCards::Cost.new(1, 0, 0, 0).common).must_equal(1)
    end

    it 'has rare cards' do
      _(RuneterraCards::Cost.new(0, 0, 0, 0).rare).must_equal(0)
      _(RuneterraCards::Cost.new(0, 1, 0, 0).rare).must_equal(1)
    end

    it 'has epic cards' do
      _(RuneterraCards::Cost.new(0, 0, 0, 0).epic).must_equal(0)
      _(RuneterraCards::Cost.new(0, 0, 1, 0).epic).must_equal(1)
    end

    it 'has champion cards' do
      _(RuneterraCards::Cost.new(0, 0, 0, 0).champion).must_equal(0)
      _(RuneterraCards::Cost.new(0, 0, 0, 1).champion).must_equal(1)
    end

    it 'can hold multiple at once' do
      cost = RuneterraCards::Cost.new(17, 8, 3, 2)
      _(cost.common).must_equal(17)
      _(cost.rare).must_equal(8)
      _(cost.epic).must_equal(3)
      _(cost.champion).must_equal(2)
    end
  end

  describe '#shards' do
    it 'gives 0 cost for 0 cards' do
      _(RuneterraCards::Cost.new(0, 0, 0, 0).shards).must_equal(0)
    end

    it 'knows how much a common card costs' do
      _(RuneterraCards::Cost.new(1, 0, 0, 0).shards).must_equal(100)
    end

    it 'knows how much two common cards cost' do
      _(RuneterraCards::Cost.new(2, 0, 0, 0).shards).must_equal(200)
    end

    it 'knows how much a rare card costs' do
      _(RuneterraCards::Cost.new(0, 1, 0, 0).shards).must_equal(300)
    end

    it 'knows how much two rare cards cost' do
      _(RuneterraCards::Cost.new(0, 2, 0, 0).shards).must_equal(600)
    end

    it 'knows how much an epic card costs' do
      _(RuneterraCards::Cost.new(0, 0, 1, 0).shards).must_equal(1200)
    end

    it 'knows how much two epic cards cost' do
      _(RuneterraCards::Cost.new(0, 0, 2, 0).shards).must_equal(2400)
    end

    it 'knows how much a champion card costs' do
      _(RuneterraCards::Cost.new(0, 0, 0, 1).shards).must_equal(3000)
    end

    it 'knows how much two champion cards cost' do
      _(RuneterraCards::Cost.new(0, 0, 0, 2).shards).must_equal(6000)
    end

    it 'can add up multiple cards' do
      _(RuneterraCards::Cost.new(13, 8, 5, 3).shards).must_equal(13 * 100 + 8 * 300 + 5 * 1200 + 3 * 3000)
    end
  end
end
