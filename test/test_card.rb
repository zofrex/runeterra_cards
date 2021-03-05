# frozen_string_literal: true

require_relative 'test_helper'
require 'set'

describe RuneterraCards::Card do
  cover 'RuneterraCards::CardAndCount'
  describe 'initialise from integers' do
    it 'pads the set' do
      card = RuneterraCards::Card.new(set: 2, faction_number: 1, card_number: 1)
      _(card.code).must_match(/^02/)
    end

    it 'looks up the faction identifier' do
      card = RuneterraCards::Card.new(set: 2, faction_number: 6, card_number: 1)
      _(card.code).must_match(/BW/)
    end

    it 'pads the card number' do
      card = RuneterraCards::Card.new(set: 2, faction_number: 6, card_number: 37)
      _(card.code).must_match(/037$/)
    end

    it 'matches exactly a whole card' do
      card = RuneterraCards::Card.new(set: 1, faction_number: 0, card_number: 123)
      _(card.code).must_equal('01DE123')
    end

    describe 'unknown faction number' do
      it 'gives a good error' do
        _{RuneterraCards::Card.new(set: 1, faction_number: 37, card_number: 1)}
          .must_raise(RuneterraCards::UnrecognizedFactionError)
      end

      it 'gives a helpful error message' do
        e = _{RuneterraCards::Card.new(set: 1, faction_number: 37, card_number: 1)}
            .must_raise(RuneterraCards::UnrecognizedFactionError)
        _(e.message).must_match(/unrecognized faction.*'37'\..*update.*library/i)
      end

      it 'includes the faction number in the error' do
        e = _{RuneterraCards::Card.new(set: 1, faction_number: 37, card_number: 1)}
            .must_raise(RuneterraCards::UnrecognizedFactionError)
        _(e.faction_number).must_equal(37)
      end
    end
  end

  describe 'initialise from card code' do
    it 'sets the code' do
      card = RuneterraCards::Card.new(code: '01DE123')
      _(card.code).must_equal('01DE123')
    end
  end

  describe 'provide integers xor card code' do # TODO: make these errors more specific? investigate
    it 'errors if you set code and set number' do
      _{RuneterraCards::Card.new(code: 'foo', set: 0)}.must_raise StandardError
    end

    it 'errors if you set code and faction' do
      _{RuneterraCards::Card.new(code: 'foo', faction_number: 0)}.must_raise StandardError
    end

    it 'errors if you set code and card number' do
      _{RuneterraCards::Card.new(code: 'foo', card_number: 0)}.must_raise StandardError
    end

    it 'errors if you provide neither code nor any integers' do
      _{RuneterraCards::Card.new}.must_raise StandardError
    end

    it 'errors if you omit set' do
      _{RuneterraCards::Card.new(faction_number: 0, card_number: 0)}.must_raise StandardError
    end

    it 'errors if you omit faction' do
      _{RuneterraCards::Card.new(set: 0, card_number: 0)}.must_raise StandardError
    end

    it 'errors if you omit card number' do
      _{RuneterraCards::Card.new(set: 0, faction_number: 0)}.must_raise StandardError
    end
  end

  describe '#eql?' do
    it 'returns true if codes are the same' do
      card1 = RuneterraCards::Card.new(set: 1, faction_number: 0, card_number: 2)
      card2 = RuneterraCards::Card.new(set: 1, faction_number: 0, card_number: 2)
      _(card1.eql?(card2)).must_equal true
    end

    it 'returns false if codes differ' do
      card1 = RuneterraCards::Card.new(set: 1, faction_number: 0, card_number: 2)
      card2 = RuneterraCards::Card.new(set: 1, faction_number: 0, card_number: 3)
      _(card1.eql?(card2)).must_equal false
    end
  end

  describe '#hash' do
    it 'is the same for two identical objects' do
      card1 = RuneterraCards::Card.new(code: '01DE044')
      card2 = RuneterraCards::Card.new(code: '01DE044')
      _(card1.hash).must_equal card2.hash
    end

    it 'is different for objects with different codes' do
      card1 = RuneterraCards::Card.new(code: '01DE044')
      card2 = RuneterraCards::Card.new(code: '01DE043')
      _(card1.hash).wont_equal card2.hash
    end

    it 'allows CardAndCount to be placed in a Set' do
      card = RuneterraCards::Card.new(code: '01DE044')
      Set[card] # won't raise
    end
  end
end
