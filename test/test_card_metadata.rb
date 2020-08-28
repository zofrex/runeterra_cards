# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::CardMetadata do
  cover 'RuneterraCards::CardMetadata'
  describe 'contains data' do
    before do
      @nautilus = { 'cardCode' => '01NX051', 'name' => 'Nautilus', 'collectible' => true, 'rarityRef' => 'Champion' }
    end

    it 'has a name' do
      card = RuneterraCards::CardMetadata.new(@nautilus)
      _(card.name).must_equal('Nautilus')
    end

    it 'has a code' do
      card = RuneterraCards::CardMetadata.new(@nautilus)
      _(card.card_code).must_equal('01NX051')
    end

    it 'has a rarity' do
      card = RuneterraCards::CardMetadata.new(@nautilus)
      _(card.rarity).must_equal(:champion)
    end

    describe 'collectible? status' do
      it 'can be true' do
        card = RuneterraCards::CardMetadata.new(@nautilus)
        _(card.collectible?).must_equal(true)
      end

      it 'can be false' do
        card = RuneterraCards::CardMetadata.new(@nautilus.merge({ 'collectible' => false }))
        _(card.collectible?).must_equal(false)
      end
    end
  end

  describe 'rarities' do
    before do
      @data = { 'cardCode' => '01NX001', 'name' => 'Fictional Card', 'collectible' => true }
    end

    it 'can be none' do
      card = RuneterraCards::CardMetadata.new(@data.merge({ 'rarityRef' => 'None' }))
      _(card.rarity).must_equal(:none)
    end

    it 'can be Common' do
      card = RuneterraCards::CardMetadata.new(@data.merge({ 'rarityRef' => 'Common' }))
      _(card.rarity).must_equal(:common)
    end

    it 'can be Rare' do
      card = RuneterraCards::CardMetadata.new(@data.merge({ 'rarityRef' => 'Rare' }))
      _(card.rarity).must_equal(:rare)
    end

    it 'can be Epic' do
      card = RuneterraCards::CardMetadata.new(@data.merge({ 'rarityRef' => 'Epic' }))
      _(card.rarity).must_equal(:epic)
    end

    it 'can be Champion' do
      card = RuneterraCards::CardMetadata.new(@data.merge({ 'rarityRef' => 'Champion' }))
      _(card.rarity).must_equal(:champion)
    end

    describe 'invalid values' do
      it 'throws an error' do
        _{RuneterraCards::CardMetadata.new(@data.merge({ 'rarityRef' => 'Legendary' }))}
          .must_raise RuneterraCards::MetadataLoadError
      end

      it 'gives a helpful error message' do
        e = _{RuneterraCards::CardMetadata.new(@data.merge({ 'rarityRef' => 'Legendary' }))}
            .must_raise RuneterraCards::MetadataLoadError
        _(e.message).must_match(/invalid value.*rarityRef.*Legendary, /i)
        _(e.message).must_match(/expected.*none, common, rare, epic, champion/i)
      end

      it 'has the card name in the error message' do
        e = _{RuneterraCards::CardMetadata.new(@data.merge({ 'rarityRef' => 'Legendary' }))}
            .must_raise RuneterraCards::MetadataLoadError
        _(e.message)
          .must_match(/Fictional Card/)
      end
    end
  end

  describe 'data is missing' do
    describe 'name is missing' do
      before do
        @hash = { 'cardCode' => '01NX055', 'collectible' => true }
      end

      it 'raises MissingCardDataError' do
        _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
      end

      it 'has a helpful error message' do
        error = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
        _(error.message).must_match(/Card 01NX055:.*missing.*key: name/i)
      end

      it 'has the card code in the error' do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
        _(err.card).must_equal('01NX055')
      end
    end

    describe 'name and cardCode are both missing' do
      before do
        @hash = { 'collectible' => true }
      end

      it 'raises MissingCardDataError' do
        _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
      end

      it 'still has a helpful error message' do
        error = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
        _(error.message).must_match(/Unknown card.*no code or name.*missing.*key.*(name|cardCode)/i)
      end
    end

    describe 'cardCode is missing' do
      before do
        @hash = { 'name' => 'House Spider', 'collectible' => true }
      end

      it 'raises MissingCardDataError' do
        _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
      end

      it 'has the card name in the helpful error message' do
        error = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
        _(error.message).must_match(/.*House Spider.*missing.*key.*cardCode/i)
      end

      it 'has the card name in the error' do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
        _(err.card).must_equal('House Spider')
      end
    end

    describe 'collectible is missing' do
      before do
        @hash = { 'cardCode' => '01NX055', 'name' => 'House Spider' }
      end

      it 'raises MissingCardDataError' do
        _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
      end

      it 'has a helpful error message' do
        error = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
        _(error.message).must_match(/.*House Spider.*missing.*key.*collectible/i)
      end

      it 'has the card name in the error' do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
        _(err.card).must_equal('House Spider')
      end
    end

    describe 'rarityRef is missing' do
      before do
        @hash = { 'cardCode' => '01NX055', 'name' => 'House Spider', 'collectible' => true }
      end

      it 'raises MissingCardDataError' do
        _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
      end

      it 'has a helpful error message' do
        error = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MetadataLoadError)
        _(error.message).must_match(/.*House Spider.*missing.*key.*rarityRef/i)
      end
    end
  end
end
