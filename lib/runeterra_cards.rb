require 'runeterra_cards/version'
require 'runeterra_cards/errors'
require 'runeterra_cards/factions'

require 'base32'

module RuneterraCards
  SUPPORTED_VERSION = 1

  def self.from_deck_code(deck_code)
    raise EmptyInputError if deck_code.empty?

    begin
      bin = Base32::decode(deck_code)
    rescue
      raise Base32Error.new
    end

    format_and_version = bin[0,1].unpack("C")[0]
    #   format = format_and_version >> 4
    version = format_and_version & 0xF

    raise UnrecognizedVersionError.new(SUPPORTED_VERSION, version) if version != SUPPORTED_VERSION
  end
end
