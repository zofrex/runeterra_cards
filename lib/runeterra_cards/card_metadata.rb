# frozen_string_literal: true

module RuneterraCards
  class CardMetadata
    attr_reader :name, :card_code

    def initialize(hash)
      @name, @card_code, @collectible = hash.fetch_values('name', 'cardCode', 'collectible')
    rescue KeyError => e
      raise MissingCardDataError.new(e.key, hash['name'] || hash['cardCode'])
    end

    def collectible?
      @collectible
    end
  end
end
