require_relative 'test_helper'

describe RuneterraCards::CardMetadata do
  describe "contains data" do
    before do
      @nautilus = {"cardCode" => "01NX051", "name" => "Nautilus", "collectible" => true}
    end

    it "has a name" do
      card = RuneterraCards::CardMetadata.new(@nautilus)
      _(card.name).must_equal("Nautilus")
    end

    it "has a code" do
      card = RuneterraCards::CardMetadata.new(@nautilus)
      _(card.cardCode).must_equal("01NX051")
    end

    describe "collectible? status" do
      it "can be true" do
        card = RuneterraCards::CardMetadata.new(@nautilus)
        _(card.collectible?).must_equal(true)
      end

      it "can be false" do
        card = RuneterraCards::CardMetadata.new(@nautilus.merge({"collectible" => false}))
        _(card.collectible?).must_equal(false)
      end
    end
  end

  describe "data is missing" do
    describe "name is missing" do
      before do
        @hash = {"cardCode" => "01NX055", "collectible" => true}
      end

      it "raises MissingCardDataError" do
        _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
      end

      it "has a helpful error message" do
        error = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(error.message).must_match(/.*01NX055.*missing.*key.*name/)
      end

      it "has the card code in the error" do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(err.card).must_equal("01NX055")
      end

      it "has the missing key in the error" do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(err.missing_key).must_equal("name")
      end
    end

    describe "name and cardCode are both missing" do
      before do
        @hash = {"collectible" => true}
      end

      it "raises MissingCardDataError" do
        _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
      end

      it "still has a helpful error message" do
        error = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(error.message).must_match(/.*missing.*key.*(name|cardCode)/)
      end

      it "still has a missing key in the error" do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(err.missing_key).must_match(/(name|cardCode)/)
      end
    end

    describe "cardCode is missing" do
      before do
        @hash = {"name" => "House Spider", "collectible" => true}
      end

      it "raises MissingCardDataError" do
        _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
      end

      it "has the card name in the helpful error message" do
        error = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(error.message).must_match(/.*House Spider.*missing.*key.*cardCode/)
      end

      it "has the card name in the error" do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(err.card).must_equal("House Spider")
      end

      it "has the missing key in the error" do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(err.missing_key).must_equal("cardCode")
      end
    end

    describe "collectible is missing" do
      before do
        @hash = {"cardCode" => "01NX055", "name" => "House Spider"}
      end

      it "raises MissingCardDataError" do
        _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
      end

      it "has a helpful error message" do
        error = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(error.message).must_match(/.*House Spider.*missing.*key.*collectible/)
      end

      it "has the card name in the error" do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(err.card).must_equal("House Spider")
      end

      it "has the missing key in the error" do
        err = _{RuneterraCards::CardMetadata.new(@hash)}.must_raise(RuneterraCards::MissingCardDataError)
        _(err.missing_key).must_equal("collectible")
      end
    end
  end
end