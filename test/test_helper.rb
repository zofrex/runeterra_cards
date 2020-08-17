require "minitest/autorun"
require 'minitest/reporters'
require 'warning'

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'runeterra_cards'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

Warning.ignore(/warning: instance variable @table not initialized/, /.*base32-0\.3\.2\/lib\/base32\.rb/)
