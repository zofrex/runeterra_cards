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

  describe '#==' do
    it 'matches for zero cost' do
      cost1 = RuneterraCards::Cost.new(0, 0, 0, 0)
      cost2 = RuneterraCards::Cost.new(0, 0, 0, 0)
      _(cost1).must_equal(cost2)
    end

    it 'returns false if common differs' do
      cost1 = RuneterraCards::Cost.new(0, 0, 0, 0)
      cost2 = RuneterraCards::Cost.new(1, 0, 0, 0)
      _(cost1).wont_equal(cost2)
    end

    it 'returns false if rare differs' do
      cost1 = RuneterraCards::Cost.new(0, 0, 0, 0)
      cost2 = RuneterraCards::Cost.new(0, 1, 0, 0)
      _(cost1).wont_equal(cost2)
    end

    it 'returns false if epic differs' do
      cost1 = RuneterraCards::Cost.new(0, 0, 0, 0)
      cost2 = RuneterraCards::Cost.new(0, 0, 1, 0)
      _(cost1).wont_equal(cost2)
    end

    it 'returns false if champion differs' do
      cost1 = RuneterraCards::Cost.new(0, 0, 0, 0)
      cost2 = RuneterraCards::Cost.new(0, 0, 0, 1)
      _(cost1).wont_equal(cost2)
    end
  end

  describe '#-' do
    describe 'minuend > subtrahend' do
      it 'subtracts common counts' do
        minuend = RuneterraCards::Cost.new(13, 8, 5, 3)
        subtrahend = RuneterraCards::Cost.new(2, 0, 0, 0)
        _(minuend - subtrahend).must_equal(RuneterraCards::Cost.new(11, 8, 5, 3))
      end

      it 'subtracts rare counts' do
        minuend = RuneterraCards::Cost.new(13, 8, 5, 3)
        subtrahend = RuneterraCards::Cost.new(0, 3, 0, 0)
        _(minuend - subtrahend).must_equal(RuneterraCards::Cost.new(13, 5, 5, 3))
      end

      it 'subtracts epic counts' do
        minuend = RuneterraCards::Cost.new(13, 8, 5, 3)
        subtrahend = RuneterraCards::Cost.new(0, 0, 4, 0)
        _(minuend - subtrahend).must_equal(RuneterraCards::Cost.new(13, 8, 1, 3))
      end

      it 'subtracts champion counts' do
        minuend = RuneterraCards::Cost.new(13, 8, 5, 3)
        subtrahend = RuneterraCards::Cost.new(0, 0, 0, 1)
        _(minuend - subtrahend).must_equal(RuneterraCards::Cost.new(13, 8, 5, 2))
      end
    end

    describe 'minuend < subtrahend' do
      it "common counts won't go below zero" do
        minuend = RuneterraCards::Cost.new(13, 8, 5, 3)
        subtrahend = RuneterraCards::Cost.new(15, 0, 0, 0)
        _(minuend - subtrahend).must_equal(RuneterraCards::Cost.new(0, 8, 5, 3))
      end

      it "rare counts won't go below zero" do
        minuend = RuneterraCards::Cost.new(13, 8, 5, 3)
        subtrahend = RuneterraCards::Cost.new(0, 20, 0, 0)
        _(minuend - subtrahend).must_equal(RuneterraCards::Cost.new(13, 0, 5, 3))
      end

      it "epic counts won't go below zero" do
        minuend = RuneterraCards::Cost.new(13, 8, 5, 3)
        subtrahend = RuneterraCards::Cost.new(0, 0, 6, 0)
        _(minuend - subtrahend).must_equal(RuneterraCards::Cost.new(13, 8, 0, 3))
      end

      it "champion counts won't go below zero" do
        minuend = RuneterraCards::Cost.new(13, 8, 5, 3)
        subtrahend = RuneterraCards::Cost.new(0, 0, 0, 5)
        _(minuend - subtrahend).must_equal(RuneterraCards::Cost.new(13, 8, 5, 0))
      end
    end
  end
end
