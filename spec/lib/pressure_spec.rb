require 'spec_helper'

describe Pressure do
  context "metric unit" do
    before { @metric_pressure = Pressure.new( 200, :metric) }

    it 'should respond correctly to conversion methods' do
      @metric_pressure.to_bar.should eql(200)
      @metric_pressure.to_psi.should eql(2900.75476)
    end

    it 'should render as a string' do
      @metric_pressure.to_s.should eql("200 bar")
      @metric_pressure.to_s(:metric).should eql("200 bar")
      @metric_pressure.to_s(:imperial).should eql("2900 psi")
    end
  end

  context "imperial unit" do
     before { @imperial_pressure = Pressure.new(1500, :imperial) }

     it 'should respond correctly to conversion methods' do
       @imperial_pressure.to_bar.should eql(103.42135920514701)
       @imperial_pressure.to_psi.should eql(1500)
     end

     it 'should render as a string' do
       @imperial_pressure.to_s.should eql("1500 psi")
       @imperial_pressure.to_s(:metric).should eql("103 bar")
       @imperial_pressure.to_s(:imperial).should eql("1500 psi")
     end
   end

   context "class methods" do
    it "should respond to :units" do
      [["psi", "imperial"], ["bar", "metric"]].each do |u|
        Pressure.units.should include(u)
      end
    end
  end
end

