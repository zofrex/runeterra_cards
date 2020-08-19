# frozen_string_literal: true

module RuneterraCards
  # Represents metadata for a single card. Metadata is all meaning the game imbues upon a card code, including things
  # like cost, health, etc and also localised information such as name and description.
  #
  # Currently this class only represents a thin sliver of metadata as required by its downstream consumers.
  #
  # @see CardAndCount
  class CardMetadata
    # Returns the name attribute. The name is the localised name that the card would have in game.
    # For example: "House Spider".
    # @return [String]
    attr_reader :name

    # Returns the card_code attribute. For example: "01NX055".
    # @return [String]
    attr_reader :card_code

    # Creates a single {CardMetadata} Object from the supplied Hash of data.
    # This is intended for use with the data files from Legends of Runeterra Data Dragon, and it expects a Hash
    # representing a single card from the parsed JSON data files from Data Dragon.
    #
    # @param hash [Hash] Card data from Legends of Runeterra Data Dragon
    # @option hash [String] name
    # @option hash [String] cardCode
    # @option hash [Boolean] collectible
    #
    # @raise [MissingCardDataError] if any of the expected hash parameters are missing
    def initialize(hash)
      @name, @card_code, @collectible = hash.fetch_values('name', 'cardCode', 'collectible')
    rescue KeyError => e
      raise MissingCardDataError.new(e.key, hash['name'] || hash['cardCode'])
    end

    # Whether or not the card is collectible.
    def collectible?
      @collectible
    end
  end
end
