require 'spec_helper'

describe Quantity do
  context "metric unit" do
    before { @quantity = Quantity.new(12345.6789, :metric) }

    it 'should return respond correctly to helper methods' do
      @quantity.should_not be_imperial
      @quantity.should be_metric
    end
  end

  context "imperial unit" do
    before { @quantity = Quantity.new(12345.6789, :imperial) }

    it 'should return respond correctly to helper methods' do
      @quantity.should be_imperial
      @quantity.should_not be_metric
    end
  end


  context "any unit" do
    before { @quantity = Quantity.new(12345.6789) }

    it 'should become imperial' do
      @quantity.imperial!
      @quantity.should be_imperial
    end

    it 'should become metric' do
      @quantity.metric!
      @quantity.should be_metric
    end
  end

  context "class methods" do
    it "should respond to :units" do
      Quantity.should respond_to(:units)
    end
  end
end


