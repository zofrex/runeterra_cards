# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::Metadata do
  cover 'RuneterraCards::Metadata'
  SET_1 = File.join(__dir__, './data/set-1.json').freeze
  SET_2 = File.join(__dir__, './data/set-2.json').freeze

  before do
    @m = RuneterraCards::Metadata.new
  end

  it 'loads a file' do
    @m.add_set_file(SET_1)
    _(@m.lookup_card('01IO012T2')).wont_be_nil
  end

  it 'gets the metadata for cards in the file' do
    @m.add_set_file(SET_1)
    card = @m.lookup_card('01DE031')
    _(card.name).must_equal 'Dawnspeakers'
  end

  describe 'adding multiple sets' do
    before do
      @m.add_set_file(SET_1)
      @m.add_set_file(SET_2)
    end

    it 'has metadata for cards in the second file added' do
      _(@m.lookup_card('02BW040')).wont_be_nil
    end

    it 'still has metadata for cards in the first file added' do
      _(@m.lookup_card('01NX020T3')).wont_be_nil
    end
  end

  describe '#all_collectible' do
    it 'returns all the collectible cards' do
      @m.add_set_file(SET_1)
      collectible = @m.all_collectible
      _(collectible['01DE031']).wont_be_nil
      _(collectible['01DE022']).wont_be_nil
    end

    it 'does not return any non-collectible cards' do
      @m.add_set_file(SET_1)
      collectible = @m.all_collectible
      _(collectible.all? {|_, card| card.collectible?}).must_equal true
    end
  end

  describe '#full_set' do
    it 'returns a CardSet of all collectible cards' do
      @m.add_set_file(SET_1)
      @m.add_set_file(SET_2)
      full_set = @m.full_set
      _(full_set.cards).must_equal({
                                     '01DE031' => 3,
                                     '01DE022' => 3,
                                     '02PZ001' => 3,
                                     '02BW040' => 3,
                                   })
    end
  end

  describe '#cost_of' do
    COMMON_CARD_1   = '01IO020'
    COMMON_CARD_2   = '01PZ007'
    RARE_CARD_1     = '01DE019'
    RARE_CARD_2     = '01NX004'
    EPIC_CARD_1     = '01DE031'
    EPIC_CARD_2     = '01PZ013'
    CHAMPION_CARD_1 = '01DE022'
    CHAMPION_CARD_2 = '01PZ056'

    before do
      @m.add_set_file(File.join(__dir__, './data/all-rarities.json'))
    end

    it 'returns 0 shards for an empty set' do
      set = RuneterraCards::CardSet.new([])
      _(@m.cost_of(set).shards).must_equal(0)
    end

    describe 'counts common cards' do
      it 'sums one card' do
        set = RuneterraCards::CardSet.new({ COMMON_CARD_1 => 1 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(1, 0, 0, 0))
      end

      it 'sums two of the same card' do
        set = RuneterraCards::CardSet.new({ COMMON_CARD_1 => 2 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(2, 0, 0, 0))
      end

      it 'sums two different cards' do
        set = RuneterraCards::CardSet.new({ COMMON_CARD_1 => 2, COMMON_CARD_2 => 3 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(5, 0, 0, 0))
      end
    end

    describe 'counts rare cards' do
      it 'sums one card' do
        set = RuneterraCards::CardSet.new({ RARE_CARD_1 => 1 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(0, 1, 0, 0))
      end

      it 'sums two of the same card' do
        set = RuneterraCards::CardSet.new({ RARE_CARD_1 => 2 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(0, 2, 0, 0))
      end

      it 'sums two different cards' do
        set = RuneterraCards::CardSet.new({ RARE_CARD_1 => 2, RARE_CARD_2 => 3 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(0, 5, 0, 0))
      end
    end

    describe 'counts epic cards' do
      it 'sums one card' do
        set = RuneterraCards::CardSet.new({ EPIC_CARD_1 => 1 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(0, 0, 1, 0))
      end

      it 'sums two of the same card' do
        set = RuneterraCards::CardSet.new({ EPIC_CARD_1 => 2 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(0, 0, 2, 0))
      end

      it 'sums two different cards' do
        set = RuneterraCards::CardSet.new({ EPIC_CARD_1 => 2, EPIC_CARD_2 => 3 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(0, 0, 5, 0))
      end
    end

    describe 'counts champion cards' do
      it 'sums one card' do
        set = RuneterraCards::CardSet.new({ CHAMPION_CARD_1 => 1 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(0, 0, 0, 1))
      end

      it 'sums two of the same card' do
        set = RuneterraCards::CardSet.new({ CHAMPION_CARD_1 => 2 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(0, 0, 0, 2))
      end

      it 'sums two different cards' do
        set = RuneterraCards::CardSet.new({ CHAMPION_CARD_1 => 2, CHAMPION_CARD_2 => 3 })
        _(@m.cost_of(set)).must_equal(RuneterraCards::Cost.new(0, 0, 0, 5))
      end
    end
  end
end
