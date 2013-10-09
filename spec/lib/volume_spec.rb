require 'spec_helper'

describe Volume do
  context "metric unit" do
    before { @metric_volume = Volume.new( 11.2, :metric) }

    it 'should write unit as a string' do
      @metric_volume.unit_name.should eql('litres')
    end

    it 'should render as a string' do
      @metric_volume.to_s.should eql("11.2 litres")
    end
  end

  context "blankly" do
     before { @blank_volume = Volume.new( '', :metric) }

     it 'should write unit as a string' do
       @blank_volume.unit_name.should eql('litres')
     end

     it 'should render as a string' do
       @blank_volume.to_s.should be_blank
     end
   end

  context "imperial unit" do
    before { @imperial_volume = Volume.new( 80, :imperial) }

    it 'should write unit as a string' do
      @imperial_volume.unit_name.should eql('cu. ft.')
    end

    it 'should render as a string' do
      @imperial_volume.to_s.should eql("80.0 cu. ft.")
    end
  end
  context "class methods" do
    it "should respond to :units" do
      [["cu. ft.", "imperial"], ["litres", "metric"]].each do |u|
        Volume.units.should include(u)
      end
    end
  end
end

