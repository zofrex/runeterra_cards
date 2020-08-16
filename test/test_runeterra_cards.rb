require_relative 'test_helper'

describe RuneterraCards do
  it "returns a version" do
    _(RuneterraCards::VERSION).must_equal "0.0.1"
  end

  describe "when given invalid data" do
    describe "invalid base32 encoding" do
      it "returns a Base32Error" do
        _{RuneterraCards::from_deck_code("ahsdkjahdjahds")}.must_raise RuneterraCards::Base32Error
      end
    end

    describe "empty input" do
      it "returns an EmptyInputError" do
        _{RuneterraCards::from_deck_code("")}.must_raise RuneterraCards::EmptyInputError
      end
    end
  end
end
