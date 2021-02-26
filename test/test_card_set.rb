# frozen_string_literal: true

require_relative 'test_helper'

# NOTE: .pack('C*') isn't the right encoding (which would be unsigned LEB128 varint),
# but it's the same for 0 <= anything < 128, so it's a convenience for easy test writing

describe RuneterraCards::CardSet do
  cover 'RuneterraCards::CardSet'

  describe 'creation and contents' do
    it 'can be empty' do
      card_set = RuneterraCards::CardSet.new({})
      _(card_set.as_cards).must_be_empty
    end

    it 'can contain a card' do
      card = RuneterraCards::Card.new(set: 1, faction_number: 0, card_number: 0)
      card_set = RuneterraCards::CardSet.new({ card.code => 1 })
      _(card_set.as_cards).must_include(card)
    end

    it 'has a count for the card' do
      card = RuneterraCards::Card.new(set: 1, faction_number: 0, card_number: 0)
      card_set = RuneterraCards::CardSet.new({ card.code => 3 })
      _(card_set.as_cards[card]).must_equal(3)
    end

    it 'can contain multiple cards' do
      card1 = RuneterraCards::Card.new(set: 1, faction_number: 0, card_number: 0)
      card2 = RuneterraCards::Card.new(set: 1, faction_number: 1, card_number: 7)
      card_set = RuneterraCards::CardSet.new({ card1.code => 2, card2.code => 3 })
      _(card_set.as_cards).must_equal({ card1 => 2, card2 => 3 })
    end
  end

  describe '#-' do
    it '3 - 1 = 2' do
      set1 = RuneterraCards::CardSet.new({ '01DE044' => 3 })
      set2 = RuneterraCards::CardSet.new({ '01DE044' => 1 })
      _((set1 - set2).cards).must_equal({ '01DE044' => 2 })
    end

    it 'removes a card if it reaches 0' do
      set1 = RuneterraCards::CardSet.new({ '01DE044' => 1 })
      set2 = RuneterraCards::CardSet.new({ '01DE044' => 1 })
      _((set1 - set2).cards).must_equal({})
    end

    it "ignores cards on the RHS that aren't in the LHS" do
      set1 = RuneterraCards::CardSet.new({ '01DE044' => 1 })
      set2 = RuneterraCards::CardSet.new({ '01DE044' => 1, '00DE017' => 1 })
      _((set1 - set2).cards).must_equal({})
    end
  end

  describe '#count_for_card_code' do
    it 'retrieves the count for a card in the set' do
      card_set = RuneterraCards::CardSet.new({ '01DE044' => 3 })
      _(card_set.count_for_card_code('01DE044')).must_equal(3)
    end

    it 'returns 0 for a card not in the set' do
      card_set = RuneterraCards::CardSet.new({ '01DE044' => 3 })
      _(card_set.count_for_card_code('00DE075')).must_equal(0)
    end
  end

  describe '#from_deck_code' do
    let(:empty_deck) do
      [0, 0, 0].pack('C*').freeze
    end

    describe 'when given invalid data' do
      describe 'invalid base32 encoding' do
        it 'returns a Base32Error' do
          _{RuneterraCards::CardSet.from_deck_code('ahsdkjahdjahds')}.must_raise RuneterraCards::Base32Error
        end

        it 'has a useful message in the error' do
          err = _{RuneterraCards::CardSet.from_deck_code('ahsdkjahdjahds')}.must_raise RuneterraCards::Base32Error
          _(err.message).must_match(/error while Base32 decoding.*invalid deck code.*bug in the Base32 handling/)
        end
      end

      describe 'empty input' do
        it 'returns an EmptyInputError' do
          _{RuneterraCards::CardSet.from_deck_code('')}.must_raise RuneterraCards::EmptyInputError
        end

        it 'returns an error with a helpful message' do
          err = _{RuneterraCards::CardSet.from_deck_code('')}.must_raise RuneterraCards::EmptyInputError
          _(err.message).must_match(/empty string/)
        end
      end

      describe 'invalid version' do
        before do
          format_and_version = (1 << 4) | (3 & 0xF) # format 1, version 3
          bytes = [format_and_version].pack('C') + empty_deck
          @code = Base32.encode(bytes)
        end

        it 'returns an UnrecognizedVersionError' do
          _{RuneterraCards::CardSet.from_deck_code(@code)}.must_raise RuneterraCards::UnrecognizedVersionError
        end

        it 'has a helpful error message' do
          err = _{RuneterraCards::CardSet.from_deck_code(@code)}.must_raise RuneterraCards::UnrecognizedVersionError
          _(err.message).must_match(/^Unrecognized.*version.*invalid deck code.*update the deck code library/)
        end

        it 'includes the version we got in the error message' do
          err = _{RuneterraCards::CardSet.from_deck_code(@code)}.must_raise RuneterraCards::UnrecognizedVersionError
          _(err.message).must_match(/Unrecognized deck code version number: 3/)
        end

        it 'includes the expected version in the error message' do
          err = _{RuneterraCards::CardSet.from_deck_code(@code)}.must_raise RuneterraCards::UnrecognizedVersionError
          _(err.message).must_match(/was expecting: 2/)
        end

        it 'includes the version we got in the error object' do
          err = _{RuneterraCards::CardSet.from_deck_code(@code)}.must_raise RuneterraCards::UnrecognizedVersionError
          _(err.version).must_equal(3)
        end
      end

      describe 'invalid format' do
        it 'returns a StandardError' do
          format_and_version = (2 << 4) | (1 & 0xF) # format 2, version 1
          bytes = [format_and_version].pack('C') + empty_deck
          code = Base32.encode(bytes)
          _{RuneterraCards::CardSet.from_deck_code(code)}.must_raise StandardError
          # TODO: change this to a more specific error
        end
      end
    end

    describe 'valid versions' do
      it 'accepts version 1' do
        format_and_version = (1 << 4) | (1 & 0xF) # format 1, version 1
        bytes = [format_and_version].pack('C') + empty_deck
        code = Base32.encode(bytes)
        RuneterraCards::CardSet.from_deck_code(code) # won't raise an exception
      end

      it 'accepts version 2' do
        format_and_version = (1 << 4) | (2 & 0xF) # format 1, version 2
        bytes = [format_and_version].pack('C') + empty_deck
        code = Base32.encode(bytes)
        RuneterraCards::CardSet.from_deck_code(code) # won't raise an exception
      end
    end

    describe 'when given valid data' do
      before do
        format_and_version = (1 << 4) | (1 & 0xF) # format 1, version 1
        @fav_bytes = [format_and_version].pack('C')
      end

      it "doesn't error for an empty deck" do
        cards = [0, 0, 0].pack('C*')
        code = Base32.encode(@fav_bytes + cards)
        RuneterraCards::CardSet.from_deck_code(code)
      end

      it 'produces an empty set for an empty deck' do
        cards = [0, 0, 0].pack('C*')
        code = Base32.encode(@fav_bytes + cards)
        card_set = RuneterraCards::CardSet.from_deck_code(code)
        _(card_set.as_cards).must_equal({})
      end

      it 'handles a single card in the 3x section' do
        cards = [1, 1, 1, 3, 17, 0, 0].pack('C*')
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

        expected = { RuneterraCards::Card.new(set: 1, faction_number: 3, card_number: 17) => 3 }
        _(card_set.as_cards).must_equal expected
      end

      it 'handles a single card in the 2x section' do
        cards = [0, 1, 1, 1, 3, 17, 0].pack('C*')
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

        expected = { RuneterraCards::Card.new(set: 1, faction_number: 3, card_number: 17) => 2 }
        _(card_set.as_cards).must_equal expected
      end

      it 'handles a single card in the 1x section' do
        cards = [0, 0, 1, 1, 1, 3, 17].pack('C*')
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

        expected = { RuneterraCards::Card.new(set: 1, faction_number: 3, card_number: 17) => 1 }
        _(card_set.as_cards).must_equal expected
      end

      describe 'creates a card with the right set number' do
        (1..2).each do |set_number|
          it "creates a card with set number #{set_number}" do
            cards = [0, 0, 1, 1, set_number, 3, 17].pack('C*')
            #        ^  ^  ^  ^              ^  ^
            #        │  │  │  │              │  └ card #
            #        │  │  │  │              └ faction
            #        │  │  │  └ how many cards in this set/faction combo
            #        │  │  └ how many set/faction lists for 1x cards
            #        │  └ how many set/faction lists for 2x cards
            #        └ how many set/faction lists for 3x cards
            code = Base32.encode(@fav_bytes + cards)

            card_set = RuneterraCards::CardSet.from_deck_code(code)
            card = card_set.as_cards.keys.first

            _(card.code).must_match(/^0#{set_number}/)
          end
        end
      end

      describe 'creates a card with the right faction' do
        { 1 => 'FR', 3 => 'NX' }.each do |faction_number, faction_identifier|
          it "creates a card with faction #{faction_identifier}" do
            cards = [0, 0, 1, 1, 1, faction_number, 17].pack('C*')
            #        ^  ^  ^  ^  ^                  ^
            #        │  │  │  │  │                  └ card #
            #        │  │  │  │  └ set
            #        │  │  │  └ how many cards in this set/faction combo
            #        │  │  └ how many set/faction lists for 1x cards
            #        │  └ how many set/faction lists for 2x cards
            #        └ how many set/faction lists for 3x cards
            code = Base32.encode(@fav_bytes + cards)

            card_set = RuneterraCards::CardSet.from_deck_code(code)
            card = card_set.as_cards.keys.first

            _(card.code).must_match(/#{faction_identifier}/)
          end
        end
      end

      describe 'creates a card with the card number' do
        (1..2).each do |card_number|
          it "creates a card with number #{card_number}" do
            cards = [0, 0, 1, 1, 1, 1, card_number].pack('C*')
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
            card = card_set.as_cards.keys.first

            _(card.code).must_match(/0#{card_number}$/)
          end
        end
      end

      it 'handles multiple set/faction lists in a single x section' do
        cards = [0, 0, 2, 1, 1, 3, 17, 1, 1, 4, 16].pack('C*')
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

        expected = {
          RuneterraCards::Card.new(set: 1, faction_number: 3, card_number: 17) => 1,
          RuneterraCards::Card.new(set: 1, faction_number: 4, card_number: 16) => 1,
        }
        _(card_set.as_cards).must_equal expected
      end

      it 'handles multiple cards in a single set/faction list' do
        cards = [0, 0, 1, 2, 1, 3, 17, 18].pack('C*')
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

        expected = {
          RuneterraCards::Card.new(set: 1, faction_number: 3, card_number: 17) => 1,
          RuneterraCards::Card.new(set: 1, faction_number: 3, card_number: 18) => 1,
        }
        _(card_set.as_cards).must_equal expected
      end

      it 'can return data as a hash of card codes to counts' do
        cards = [0, 0, 1, 2, 1, 3, 17, 18].pack('C*')
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

        expected = {
          '01NX017' => 1,
          '01NX018' => 1,
        }
        _(card_set.cards).must_equal expected
      end

      it 'handles card numbers > 127' do
        cards = [0, 0, 1, 1, 1, 3, 0b10000000, 0b00000001].pack('C*')
        #        ^  ^  ^  ^  ^  ^  ^           ^
        #        │  │  │  │  │  │  └───────────┴ card # (128 in ULEB128 encoding)
        #        │  │  │  │  │  └ faction
        #        │  │  │  │  └ set
        #        │  │  │  └ how many cards in this set/faction combo
        #        │  │  └ how many set/faction lists for 1x cards
        #        │  └ how many set/faction lists for 2x cards
        #        └ how many set/faction lists for 3x cards
        code = Base32.encode(@fav_bytes + cards)

        card_set = RuneterraCards::CardSet.from_deck_code(code)

        expected = { RuneterraCards::Card.new(set: 1, faction_number: 3, card_number: 128) => 1 }
        _(card_set.as_cards).must_equal expected
      end

      it 'handles set/faction lists > 127 in length' do
        cards = [0, 0, 1, 0b10000000, 0b00000001, 1, 1]
        #        ^  ^  ^  ^           ^           ^  ^
        #        │  │  │  │           │           │  │
        #        │  │  │  │           │           │  └ faction
        #        │  │  │  │           │           └ set
        #        │  │  │  └───────────┴─ how many cards in this set/faction combo (128 in ULEB128 encoding)
        #        │  │  └ how many set/faction lists for 1x cards
        #        │  └ how many set/faction lists for 2x cards
        #        └ how many set/faction lists for 3x cards

        cards += (0..127).to_a
        cards = cards.pack('C*')

        code = Base32.encode(@fav_bytes + cards)

        card_set = RuneterraCards::CardSet.from_deck_code(code)

        expected =
          (0..127).map do |card_number|
            [RuneterraCards::Card.new(set: 1, faction_number: 1, card_number: card_number), 1]
          end

        _(card_set.as_cards).must_equal expected.to_h
      end
    end
  end
end
