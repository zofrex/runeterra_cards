require "minitest/autorun"

class TestRuneterraCards < Minitest::Test
  def test_version
    assert_equal "0.0.1", RuneterraCards::VERSION
  end
end
