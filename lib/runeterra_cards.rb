# frozen_string_literal: true

require 'runeterra_cards/version'
require 'runeterra_cards/errors'
require 'runeterra_cards/factions'
require 'runeterra_cards/card_and_count'
require 'runeterra_cards/card_metadata'

require 'base32'

module RuneterraCards
  SUPPORTED_VERSION = 1

  def self.from_deck_code(deck_code)
    raise EmptyInputError if deck_code.empty?

    begin
      bin = Base32.decode(deck_code)
    rescue StandardError
      raise Base32Error
    end

    format_and_version = bin[0].unpack1('C')
    #   format = format_and_version >> 4
    version = format_and_version & 0xF

    raise UnrecognizedVersionError.new(SUPPORTED_VERSION, version) if version != SUPPORTED_VERSION
  end
end
