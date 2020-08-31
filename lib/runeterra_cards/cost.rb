# frozen_string_literal: true

module RuneterraCards
  # Represents the cost of a [CardSet], in terms of shards and wildcards
  class Cost
    # @return [FixNum]
    attr_reader :common
    # @return [FixNum]
    attr_reader :rare
    # @return [FixNum]
    attr_reader :epic
    # @return [FixNum]
    attr_reader :champion

    def initialize(common, rare, epic, champion)
      @common, @rare, @epic, @champion = common, rare, epic, champion
    end

    def shards
      common * 100 +
        rare * 300 +
        epic * 1200 +
        champion * 3000
    end
  end
end
