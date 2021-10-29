# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'

if ENV['LOAD_MUTANT']
  # Only load mutant if the env var is set, so we can skip loading the gem at all for normal unit test runs
  require 'mutant/minitest/coverage'
else
  # If we don't load mutant, we need to stub the `cover` method to avoid errors
  module CoverageStub
    def cover(expression)
      # this method intentionally left blank
    end
  end
  Minitest::Test.extend(CoverageStub)
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'runeterra_cards'

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]
