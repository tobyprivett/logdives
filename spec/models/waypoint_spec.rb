require 'spec_helper'

describe Waypoint do
  before { @waypoint = Waypoint.new }

  context "formatting depth" do
    before do
      @waypoint.depth_amount = 111
      @waypoint.depth_unit = :imperial
    end

    it "should have a depth" do
      @waypoint.depth.to_s.should eql("111.0 ft")
    end

    it "should have a default duration" do
      @waypoint.duration.should eql(1)
    end
  end

  context "nested_attributes_workaround" do
    context "with :nested" do
      before { @waypoint.nested  = true }

      it "should not require dive_id" do
        @waypoint.should have(0).errors_on(:dive_id)
      end
    end

    context "without :nested" do
      it "should require dive_id" do
        @waypoint.should have(1).error_on(:dive_id)
      end
    end
  end
end
