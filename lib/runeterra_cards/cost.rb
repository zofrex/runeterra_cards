# frozen_string_literal: true

# @todo could be more obvious what's wrong when you call == on the wrong class e.g. a number
module RuneterraCards
  # Represents the cost of a {CardSet}, as wildcards or shards.
  # To get the cost of a {CardSet} you need to call {Metadata#cost_of}, as rarity (and therefore cost) is a property
  # of metadata.
  #
  # A {Cost} object tells you how many wildcards would be needed to craft a {CardSet}, or alternatively how many
  # shards would be needed. You can figure out the cost of a mixture of wildcards and shards by creating a new {Cost}
  # object representing the wildcards to be spent, and subtracting that from the original {Cost} object.
  #
  # @example Getting the shard cost for a {CardSet}
  #   cost = metadata.cost_of(card_set)
  #   cost.shards #=> 3000
  #
  # @example Getting wildcard costs for a {CardSet}
  #   cost = metadata.cost_of(card_set)
  #   cost.common #=> 3
  #   cost.rare #=> 1
  #   # etc
  #
  # @example Getting remaining cost after spending some wildcards
  #   cost = metadata.cost_of(card_set)
  #   cost.dust #=> 11500
  #
  #   wildcards_in_hand = Cost.new(10, 5, 3, 1)
  #   remaining_cost = cost - wildcards_in_hand
  #   remaining_cost.dust #=> 5100
  class Cost
    # The number of Common wildcards needed
    # @return [Fixnum] count
    attr_reader :common

    # The number of Rare wildcards needed
    # @return [Fixnum] count
    attr_reader :rare

    # The number of Epic wildcards needed
    # @return [Fixnum] count
    attr_reader :epic

    # The number of Champion wildcards needed
    # @return [Fixnum] count
    attr_reader :champion

    # @param [Fixnum] common
    # @param [Fixnum] rare
    # @param [Fixnum] epic
    # @param [Fixnum] champion
    def initialize(common, rare, epic, champion)
      @common, @rare, @epic, @champion = common, rare, epic, champion
    end

    # The number of shards needed. I.e. the equivalent amount of shards for all these wildcards.
    # @return [Fixnum] shards
    def shards
      common * 100 +
        rare * 300 +
        epic * 1200 +
        champion * 3000
    end

    # Whether this Cost is equal to another. Equality means exactly the same number of each wildcard, not just the
    # same shard count.
    # @param [Cost] other an object that response to {#common}, {#rare}, {#epic}, and {#champion}.
    # @return [Boolean] equal?
    def ==(other)
      common.equal?(other.common) &&
        rare.equal?(other.rare) &&
        epic.equal?(other.epic) &&
        champion.equal?(other.champion)
    end

    # Subtracts another Cost from this one. Subtraction is performed by subtracting each wildcard type individually,
    # not by operating on the shard count. The minimum value any wildcard will have is zero, so +5 - 7 = 0+ for
    # example.
    # @note This will not return negative values.
    # @param [Cost] other an object that response to {#common}, {#rare}, {#epic}, and {#champion}.
    # @return [Cost] The remaining cost, with a floor of 0.
    # @example
    #   minuend    = Cost.new(9, 8, 5, 2)
    #   subtrahend = Cost.new(7, 8, 2, 3)
    #   result = minuend - subtrahend
    #   result   #=> Cost.new(2, 0, 3, 0)
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
