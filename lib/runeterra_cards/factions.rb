# frozen_string_literal: true

module RuneterraCards
  # An array of the two-letter Faction identifiers, indexed by their integer identifiers
  # @example
  #   FACTION_IDENTIFIERS_FROM_INT[2] #=> "IO"
  # @return [Array<String>]
  FACTION_IDENTIFIERS_FROM_INT = %w[DE FR IO NX PZ SI BW].freeze

  # A map from two-letter Faction identifiers to their integer identifiers
  # @example
  #   FACTION_INTS_FROM_IDENTIFIER["IO"] #=> 2
  # @return [Hash<String,Fixnum>]
  FACTION_INTS_FROM_IDENTIFIER = {
    'DE' => 0,
    'FR' => 1,
    'IO' => 2,
    'NX' => 3,
    'PZ' => 4,
    'SI' => 5,
    'BW' => 6,
  }.freeze
end
