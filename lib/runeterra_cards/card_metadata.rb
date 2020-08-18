module RuneterraCards
  class CardMetadata
    attr_reader :name, :cardCode

    def initialize(hash)
      begin
        @name, @cardCode, @collectible = hash.fetch_values("name", "cardCode", "collectible")
      rescue KeyError => e
        raise MissingCardDataError.new(e.key, hash["name"] || hash["cardCode"])
      end
    end

    def collectible?
      @collectible
    end
  end
end
