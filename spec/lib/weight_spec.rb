require 'spec_helper'

describe Weight do
  context "metric unit" do
    before { @metric_weight = Weight.new( 4, :metric) }

    it 'should respond correctly to conversion methods' do
      @metric_weight.to_kg.should eql(4)
      @metric_weight.to_lb.should eql(8.818490487395103)
    end

    it 'should render as a string' do
      @metric_weight.to_s.should eql("4.0 kg")
      @metric_weight.to_s(:metric).should eql("4.0 kg")
      @metric_weight.to_s(:imperial).should eql("8.8 lb")
    end
  end

  context "imperial unit" do
     before { @imperial_weight = Weight.new(18, :imperial) }

     it 'should respond correctly to conversion methods' do
       @imperial_weight.to_kg.should eql(8.164662660000001)
       @imperial_weight.to_lb.should eql(18)
     end

     it 'should render as a string' do
       @imperial_weight.to_s.should eql("18.0 lb")
       @imperial_weight.to_s(:metric).should eql("8.2 kg")
       @imperial_weight.to_s(:imperial).should eql("18.0 lb")
     end
   end

   context "class methods" do

     it "should respond to :units" do
        [['lb', "imperial"], ['kg', "metric"]].each do |u|
          Weight.units.should include(u)
        end
      end
  end
end


