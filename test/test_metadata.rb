# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::Metadata do
  SET_1 = File.join(__dir__, './data/set-1.json').freeze

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
