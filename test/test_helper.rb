require "minitest/autorun"
require 'minitest/reporters'

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'runeterra_cards'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]
