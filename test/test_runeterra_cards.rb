# frozen_string_literal: true

require_relative 'test_helper'

describe RuneterraCards do
  cover 'RuneterraCards::VERSION'
  it 'returns a version' do
    _(RuneterraCards::VERSION).must_equal '0.0.1'
  end
end
