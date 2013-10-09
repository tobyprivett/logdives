require 'spec_helper'

class MyObject
  attr_accessor :units
  include Units
end

describe Units do
  before { @obj = MyObject.new }

  it 'should respond to :units' do
    @obj.should respond_to(:units)
  end


  it "should be metric by default" do
    @obj.metric?.should be_true
    @obj.imperial?.should be_false
    @obj.alt_units.should eql(:imperial)
  end


  context "changing to imperial" do
    before { @obj.imperial! }

    it 'should be imperial' do
      @obj.metric?.should be_false
      @obj.imperial?.should be_true
      @obj.alt_units.should eql(:metric)
    end

    context " back to metric" do
      before { @obj.metric! }

      it "should be metric" do
        @obj.metric?.should be_true
        @obj.imperial?.should be_false
        @obj.alt_units.should eql(:imperial)
      end
    end
  end


  context "depth and alt_depth" do
    it 'should know metres' do
      @obj.metric!
      @obj.depth_unit.should eql('metres')
      @obj.depth_unit_abbrev.should eql('m')
      @obj.alt_depth_unit.should eql('feet')
    end

    it 'should know feet' do
      @obj.imperial!
      @obj.depth_unit.should eql('feet')
      @obj.depth_unit_abbrev.should eql('ft')
      @obj.alt_depth_unit.should eql('metres')
    end
  end

end
