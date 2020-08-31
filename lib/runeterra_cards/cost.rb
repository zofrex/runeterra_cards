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

    def ==(other)
      common.equal?(other.common) &&
        rare.equal?(other.rare) &&
        epic.equal?(other.epic) &&
        champion.equal?(other.champion)
    end

    def -(other)
      Cost.new(
        [common   - other.common,   0].max,
        [rare     - other.rare,     0].max,
        [epic     - other.epic,     0].max,
        [champion - other.champion, 0].max
      )
    end
  end
end
