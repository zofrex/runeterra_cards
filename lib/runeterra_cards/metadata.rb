# frozen_string_literal: true

require 'json'

module RuneterraCards
  # Loads, stores, and retrieves data for cards from Legends of Runeterra Data Dragon set files.
  # N.B. this does not ship with any metadata of its own, you must provide set files yourself and load them before
  # this class will do anything.
  #
  # @example Load data and retrieve data for a card
  #   m = RuneterraCards::Metadata.new
  #   m.add_set_file('./set1-en_us.json')
  #   m.lookup_card('01DE031') #=> CardMetadata
  #
  # @example Load data from multiple sets
  #   m = RuneterraCards::Metadata.new
  #   m.add_set_file('./set1-en_us.json')
  #   m.add_set_file('./set2-en_us.json')
  #
  # @todo test multiple sets
  #
  # @note This class cannot yet handle metadata for multiple locales at the same time. You will need multiple instances
  #   of this class, one for each locale, if you wish to handle multiple locales at this time.
  class Metadata
    def initialize
      @cards = {}
    end

    # Load card data from a Legends of Runeterra Data Dragon set file, e.g. "set1-en_us.json"
    # @param file_path [String] The path to the metadata file to read
    # @todo document and test exceptions that can be thrown here
    def add_set_file(file_path)
      file = File.read(file_path)
      data = JSON.parse(file)
      data.each do |card_data|
        card = CardMetadata.new(card_data)
        @cards[card.card_code] = card
      end
    end

    # Fetch card metadata for a card via its card code
    # @param card_code [String] card code, e.g. 01DE031
    # @return [CardMetadata]
    def lookup_card(card_code)
      @cards[card_code]
    end

    # Returns all cards in the metadata set that are collectible
    # @return [Hash<String,CardMetadata>]
    # @see CardMetadata#collectible?
    def all_collectible
      @cards.select { |_, card| card.collectible? }
    end
  end
end
