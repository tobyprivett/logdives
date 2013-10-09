require 'spec_helper'

describe Condition do
  before { @condition = Condition.new }

  it "should require a name" do
    @condition.should have(1).error_on(:name)
  end
end
