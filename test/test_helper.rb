# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'

require 'mutant/minitest/coverage'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'runeterra_cards'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
