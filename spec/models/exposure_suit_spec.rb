require 'spec_helper'

describe ExposureSuit do
  before { @exposure_suit = ExposureSuit.new }

  it "should require a name" do
    @exposure_suit.should have(1).error_on(:name)
  end
end
