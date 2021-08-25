# frozen_string_literal: true

require 'runeterra_cards/version'
require 'runeterra_cards/errors'
require 'runeterra_cards/factions'
require 'runeterra_cards/card'
require 'runeterra_cards/card_metadata'
require 'runeterra_cards/metadata'
require 'runeterra_cards/card_set'
require 'runeterra_cards/cost'

# The top-level module for +runeterra_cards+.
#
# Some of the most useful classes are {CardSet} and {Metadata}.
#
# You might also want to check out the {file:doc/README.md} and the {file:doc/CHANGELOG.md}.
module RuneterraCards
  # The version of deck encoding supported
  SUPPORTED_VERSION = 4
  public_constant :SUPPORTED_VERSION
end
