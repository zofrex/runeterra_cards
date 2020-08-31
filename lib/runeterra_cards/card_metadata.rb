# frozen_string_literal: true

module RuneterraCards
  # Represents metadata for a single card. Metadata is all meaning the game imbues upon a card code, including things
  # like cost, health, etc and also localised information such as name and description.
  #
  # Currently this class only represents a thin sliver of metadata as required by its downstream consumers.
  #
  # @see CardAndCount
  class CardMetadata
    RARITIES = {
      'None' => :none,
      'Common' => :common,
      'Rare' => :rare,
      'Epic' => :epic,
      'Champion' => :champion,
    }.freeze
    private_constant :RARITIES

    # Returns the name attribute. The name is the localised name that the card would have in game.
    # For example: "House Spider".
    # @return [String]
    attr_reader :name

    # Returns the card_code attribute. For example: "01NX055".
    # @return [String]
    attr_reader :card_code

    # Returns the card's rarity as a symbol. Can be one of: +:none+, +:common+, +:rare+, +:epic+, or +:champion+
    # @return [Symbol]
    attr_reader :rarity

    # Creates a single {CardMetadata} Object from the supplied Hash of data.
    # This is intended for use with the data files from Legends of Runeterra Data Dragon, and it expects a Hash
    # representing a single card from the parsed JSON data files from Data Dragon.
    #
    # @param hash [Hash] Card data from Legends of Runeterra Data Dragon
    # @option hash [String] name
    # @option hash [String] cardCode
    # @option hash [Boolean] collectible
    #
    # @raise [MissingCardDataError] if any of the expected hash parameters are missing, or if +rarityRef+ contains an
    #   unexpected value.
    def initialize(hash)
      begin
        @name, @card_code, @collectible, rarity_ref = hash.fetch_values('name', 'cardCode', 'collectible', 'rarityRef')
      rescue KeyError => e
        raise MetadataLoadError.new(hash['name'] || hash['cardCode'], "Missing expected key: #{e.key}")
      end

      @rarity = RARITIES[rarity_ref]
      return unless rarity.nil?

      raise MetadataLoadError.invalid_rarity(name, rarity_ref, RARITIES.keys)
    end

    # Whether or not the card is collectible.
    def collectible?
      @collectible
    end
  end
end
