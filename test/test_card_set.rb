# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::CardSet do
  describe 'creation and retrieval' do
    it 'can be empty' do
      card_set = RuneterraCards::CardSet.new([])
      _(card_set.cards).must_be_empty
    end

    it 'can contain a card' do
      card = RuneterraCards::CardAndCount.new(1, 0, 0, 2)
      card_set = RuneterraCards::CardSet.new([card])
      _(card_set.cards).must_include(card)
    end

    it 'can contain multiple cards' do
      card1 = RuneterraCards::CardAndCount.new(1, 0, 0, 2)
      card2 = RuneterraCards::CardAndCount.new(1, 1, 7, 3)
      card_set = RuneterraCards::CardSet.new([card1, card2])
      _(card_set.cards).must_equal(Set[card1, card2])
    end
  end

  describe '#from_deck_code' do
    describe 'when given invalid data' do
      EMPTY_DECK = [0, 0, 0].pack('w*').freeze

      describe 'invalid base32 encoding' do
        it 'returns a Base32Error' do
          _{RuneterraCards::CardSet.from_deck_code('ahsdkjahdjahds')}.must_raise RuneterraCards::Base32Error
        end
      end

      describe 'empty input' do
        it 'returns an EmptyInputError' do
          _{RuneterraCards::CardSet.from_deck_code('')}.must_raise RuneterraCards::EmptyInputError
        end
      end

      describe 'invalid version' do
        it 'returns an UnrecognizedVersionError' do
          format_and_version = (1 << 4) | (2 & 0xF) # format 1, version 2
          bytes = [format_and_version].pack('C') + EMPTY_DECK
          code = Base32.encode(bytes)
          _{RuneterraCards::CardSet.from_deck_code(code)}.must_raise RuneterraCards::UnrecognizedVersionError
        end

        it 'includes the version we got in the error message' do
          format_and_version = (1 << 4) | (2 & 0xF) # format 1, version 2
          bytes = [format_and_version].pack('C') + EMPTY_DECK
          code = Base32.encode(bytes)
          err = _{RuneterraCards::CardSet.from_deck_code(code)}.must_raise RuneterraCards::UnrecognizedVersionError
          _(err.message).must_match(/Unrecognized deck code version number: 2/)
        end

        it 'includes the expected version in the error message' do
          format_and_version = (1 << 4) | (2 & 0xF) # format 1, version 2
          bytes = [format_and_version].pack('C') + EMPTY_DECK
          code = Base32.encode(bytes)
          err = _{RuneterraCards::CardSet.from_deck_code(code)}.must_raise RuneterraCards::UnrecognizedVersionError
          _(err.message).must_match(/was expecting: 1/)
        end
      end

      describe 'invalid format' do
        it 'returns a StandardError' do
          format_and_version = (2 << 4) | (1 & 0xF) # format 2, version 1
          bytes = [format_and_version].pack('C') + EMPTY_DECK
          code = Base32.encode(bytes)
          _{RuneterraCards::CardSet.from_deck_code(code)}.must_raise StandardError
          # TODO: change this to a more specific error
        end
      end
    end

    describe 'when given valid data' do
      before do
        format_and_version = (1 << 4) | (1 & 0xF) # format 1, version 1
        @fav_bytes = [format_and_version].pack('C')
      end

      it "doesn't error for an empty deck" do
        cards = [0, 0, 0].pack('w*')
        code = Base32.encode(@fav_bytes + cards)
        RuneterraCards::CardSet.from_deck_code(code)
      end

      it 'produces an empty set for an empty deck' do
        cards = [0, 0, 0].pack('w*')
        code = Base32.encode(@fav_bytes + cards)
        card_set = RuneterraCards::CardSet.from_deck_code(code)
        _(card_set.cards).must_equal Set.new
      end

      it 'handles a single card in the 3x section' do
        cards = [1, 1, 1, 3, 17, 0, 0].pack('w*')
        #        ^  ^  ^  ^  ^   ^  ^
        #        │  │  │  │  │   │  └ how many set/faction lists for 1x
        #        │  │  │  │  │   └ how many set/faction lists for 2x
        #        │  │  │  │  └ card #
        #        │  │  │  └ faction
        #        │  │  └ set
        #        │  └ how many cards in this set/faction combo
        #        └ how many set/faction lists for 3x cards
        code = Base32.encode(@fav_bytes + cards)

        card_set = RuneterraCards::CardSet.from_deck_code(code)

        expected = Set[RuneterraCards::CardAndCount.new(1, 3, 17, 3)]
        _(card_set.cards).must_equal expected
      end

      it 'handles a single card in the 2x section' do
        cards = [0, 1, 1, 1, 3, 17, 0].pack('w*')
        #        ^  ^  ^  ^  ^  ^   ^
        #        │  │  │  │  │  │   └ how many set/faction lists for 1x cards
        #        │  │  │  │  │  └ card #
        #        │  │  │  │  └ faction
        #        │  │  │  └ set
        #        │  │  └ how many cards in this set/faction combo
        #        │  └ how many set/faction lists for 2x cards
        #        └ how many set/faction lists for 3x cards
        code = Base32.encode(@fav_bytes + cards)

        card_set = RuneterraCards::CardSet.from_deck_code(code)

        expected = Set[RuneterraCards::CardAndCount.new(1, 3, 17, 2)]
        _(card_set.cards).must_equal expected
      end

      it 'handles a single card in the 1x section' do
        cards = [0, 0, 1, 1, 1, 3, 17].pack('w*')
        #        ^  ^  ^  ^  ^  ^  ^
        #        │  │  │  │  │  │  └ card #
        #        │  │  │  │  │  └ faction
        #        │  │  │  │  └ set
        #        │  │  │  └ how many cards in this set/faction combo
        #        │  │  └ how many set/faction lists for 1x cards
        #        │  └ how many set/faction lists for 2x cards
        #        └ how many set/faction lists for 3x cards
        code = Base32.encode(@fav_bytes + cards)

        card_set = RuneterraCards::CardSet.from_deck_code(code)

        expected = Set[RuneterraCards::CardAndCount.new(1, 3, 17, 1)]
        _(card_set.cards).must_equal expected
      end

      describe 'creates a card with the right set number' do
        (1..2).each do |set_number|
          it "creates a card with set number #{set_number}" do
            cards = [0, 0, 1, 1, set_number, 3, 17].pack('w*')
            #        ^  ^  ^  ^              ^  ^
            #        │  │  │  │              │  └ card #
            #        │  │  │  │              └ faction
            #        │  │  │  └ how many cards in this set/faction combo
            #        │  │  └ how many set/faction lists for 1x cards
            #        │  └ how many set/faction lists for 2x cards
            #        └ how many set/faction lists for 3x cards
            code = Base32.encode(@fav_bytes + cards)

            card_set = RuneterraCards::CardSet.from_deck_code(code)
            card = card_set.cards.first

            _(card.code).must_match(/^0#{set_number}/)
          end
        end
      end

      describe 'creates a card with the right faction' do
        { 1 => 'FR', 3 => 'NX' }.each do |faction_number, faction_identifier|
          it "creates a card with faction #{faction_identifier}" do
            cards = [0, 0, 1, 1, 1, faction_number, 17].pack('w*')
            #        ^  ^  ^  ^  ^                  ^
            #        │  │  │  │  │                  └ card #
            #        │  │  │  │  └ set
            #        │  │  │  └ how many cards in this set/faction combo
            #        │  │  └ how many set/faction lists for 1x cards
            #        │  └ how many set/faction lists for 2x cards
            #        └ how many set/faction lists for 3x cards
            code = Base32.encode(@fav_bytes + cards)

            card_set = RuneterraCards::CardSet.from_deck_code(code)
            card = card_set.cards.first

            _(card.code).must_match(/#{faction_identifier}/)
          end
        end
      end

      describe 'creates a card with the card number' do
        (1..2).each do |card_number|
          it "creates a card with number #{card_number}" do
            cards = [0, 0, 1, 1, 1, 1, card_number].pack('w*')
            #        ^  ^  ^  ^  ^  ^  ^
            #        │  │  │  │  │  │  └ card #
            #        │  │  │  │  │  └ faction
            #        │  │  │  │  └ set
            #        │  │  │  └ how many cards in this set/faction combo
            #        │  │  └ how many set/faction lists for 1x cards
            #        │  └ how many set/faction lists for 2x cards
            #        └ how many set/faction lists for 3x cards
            code = Base32.encode(@fav_bytes + cards)

            card_set = RuneterraCards::CardSet.from_deck_code(code)
            card = card_set.cards.first

            _(card.code).must_match(/0#{card_number}$/)
          end
        end
      end

      it 'handles multiple set/faction lists in a single x section' do
        cards = [0, 0, 2, 1, 1, 3, 17, 1, 1, 4, 16].pack('w*')
        #        ^  ^  ^  ^  ^  ^  ^   ^  ^  ^  ^
        #        │  │  │  │  │  │  │   │  │  │  └ card #
        #        │  │  │  │  │  │  │   │  │  └ faction
        #        │  │  │  │  │  │  │   │  └ set
        #        │  │  │  │  │  │  │   └ how many cards in this set/faction combo
        #        │  │  │  │  │  │  └ card #
        #        │  │  │  │  │  └ faction
        #        │  │  │  │  └ set
        #        │  │  │  └ how many cards in this set/faction combo
        #        │  │  └ how many set/faction lists for 1x cards
        #        │  └ how many set/faction lists for 2x cards
        #        └ how many set/faction lists for 3x cards
        code = Base32.encode(@fav_bytes + cards)

        card_set = RuneterraCards::CardSet.from_deck_code(code)

        expected = Set[
          RuneterraCards::CardAndCount.new(1, 3, 17, 1),
          RuneterraCards::CardAndCount.new(1, 4, 16, 1),
        ]
        _(card_set.cards).must_equal expected
      end

      it 'handles multiple cards in a single set/faction list' do
        cards = [0, 0, 1, 2, 1, 3, 17, 18].pack('w*')
        #        ^  ^  ^  ^  ^  ^  ^   ^
        #        │  │  │  │  │  │  │   └ card #
        #        │  │  │  │  │  │  └ card #
        #        │  │  │  │  │  └ faction
        #        │  │  │  │  └ set
        #        │  │  │  └ how many cards in this set/faction combo
        #        │  │  └ how many set/faction lists for 1x cards
        #        │  └ how many set/faction lists for 2x cards
        #        └ how many set/faction lists for 3x cards
        code = Base32.encode(@fav_bytes + cards)

        card_set = RuneterraCards::CardSet.from_deck_code(code)

        expected = Set[
            RuneterraCards::CardAndCount.new(1, 3, 17, 1),
            RuneterraCards::CardAndCount.new(1, 3, 18, 1),
        ]
        _(card_set.cards).must_equal expected
      end
    end
  end
end
