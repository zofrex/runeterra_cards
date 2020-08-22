# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards::CardSet do
  describe 'when given invalid data' do
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

    describe 'invalid version input' do
      it 'returns an UnrecognizedVersionError' do
        format_and_version = (1 << 4) | (2 & 0xF) # format 1, version 2
        bytes = [format_and_version].pack('C')
        code = Base32.encode(bytes)
        _{RuneterraCards::CardSet.from_deck_code(code)}.must_raise RuneterraCards::UnrecognizedVersionError
      end
    end
  end
end
