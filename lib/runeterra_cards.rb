require 'runeterra_cards/version'
require 'runeterra_cards/errors'

require 'base32'

module RuneterraCards
  def self.from_deck_code(deck_code)
    raise EmptyInputError if deck_code.empty?

    begin
      bin = Base32::decode(deck_code)
    rescue
      raise Base32Error.new
    end
  end
end
