# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'

if ENV['LOAD_MUTANT']
  require 'mutant/minitest/coverage'
else
  module CoverageStub
    def cover(expression)
    end
  end
  Minitest::Test.extend(CoverageStub)
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'runeterra_cards'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
