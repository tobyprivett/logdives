require 'spec_helper'

describe Temperature do
  context "metric unit" do
    before { @metric_temperature = Temperature.new(25, :metric) }

    it 'should respond correctly to conversion methods' do
      @metric_temperature.to_deg_c.should eql(25)
      @metric_temperature.to_deg_f.should eql(77)
    end

    it 'should render as a string' do
      @metric_temperature.to_s.should eql("25.0 #{deg_c}")
      @metric_temperature.to_s(:metric).should eql("25.0 #{deg_c}")
      @metric_temperature.to_s(:imperial).should eql("77.0 #{deg_f}")
    end
  end

  context "imperial unit" do
     before { @imperial_temperature = Temperature.new(72, :imperial) }

     it 'should respond correctly to conversion methods' do
       @imperial_temperature.to_deg_c.should eql(22)
       @imperial_temperature.to_deg_f.should eql(72)
     end

     it 'should render as a string' do
       @imperial_temperature.to_s.should eql("72.0 #{deg_f}")
       @imperial_temperature.to_s(:metric).should eql("22.0 #{deg_c}")
       @imperial_temperature.to_s(:imperial).should eql("72.0 #{deg_f}")
     end
   end

   context "class methods" do

     it "should respond to :units" do
        [[deg_f, "imperial"], [deg_c, "metric"]].each do |u|
          Temperature.units.should include(u)
        end
      end
  end
end

def deg_f; Temperature.deg_f; end
def deg_c; Temperature.deg_c; end
