# frozen_string_literal: true

module RuneterraCards
  # An map from integer faction identifiers to their two-letter identifiers
  # @example
  #   FACTION_IDENTIFIERS_FROM_INT[2] #=> "IO"
  # @return [Hash<Fixnum,String>]
  FACTION_IDENTIFIERS_FROM_INT = {
    0 => 'DE',
    1 => 'FR',
    2 => 'IO',
    3 => 'NX',
    4 => 'PZ',
    5 => 'SI',
    6 => 'BW',
    9 => 'MT',
  }.freeze
  public_constant :FACTION_IDENTIFIERS_FROM_INT

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
    'MT' => 9,
  }.freeze
  public_constant :FACTION_INTS_FROM_IDENTIFIER
end
