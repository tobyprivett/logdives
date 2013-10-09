require 'spec_helper'

describe Depth do
  context "metric unit" do
    before { @metric_depth = Depth.new( 12345.6789, :metric) }

    it 'should respond correctly to conversion methods' do
      @metric_depth.to_metres.should eql(12345.6789)
      @metric_depth.to_feet.should eql(40504.19586614174)
    end

    it 'should render as a string' do
      @metric_depth.to_s.should eql("12345.7 m")
      @metric_depth.to_s(:metric).should eql("12345.7 m")
      @metric_depth.to_s(:imperial).should eql("40504.2 ft")
    end

    it 'should write unit as a string' do
      @metric_depth.unit_name.should eql('metres')
    end
  end

  context "imperial unit" do
    before { @imperial_depth = Depth.new(12345.6789, :imperial) }

    it 'should respond correctly to conversion methods' do
      @imperial_depth.to_metres.should eql(3762.96292872)
      @imperial_depth.to_feet.should eql(12345.6789)
    end

    it 'should render as a string' do
      @imperial_depth.to_s.should eql("12345.7 ft")
      @imperial_depth.to_s(:metric).should eql("3763.0 m")
      @imperial_depth.to_s(:imperial).should eql("12345.7 ft")
    end

    it 'should write unit as a string' do
      @imperial_depth.unit_name.should eql('feet')
    end
  end

  context "class methods" do
    it "should respond to :units" do
      [["feet", "imperial"], ["metres", "metric"]].each do |u|
        Depth.units.should include(u)
      end
    end
  end
end

