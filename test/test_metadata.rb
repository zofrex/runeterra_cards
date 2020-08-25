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
end
