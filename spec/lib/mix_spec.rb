require 'spec_helper.rb'

describe Mix do
  context "Air" do
    before { @mix = Mix.new }

    it "should be air" do
      @mix.to_s.should eql('Air')
    end
  end

  context "Nitrox" do
    before { @mix = Mix.new 'Nitrox', 36 }

    it "should be nitrox 36" do
      @mix.to_s.should eql('Nitrox 36')
    end
  end

  context "Trimix" do
    before { @mix = Mix.new 'Trimix', 18, 35 }

    it "should be trimix 18/35" do
      @mix.to_s.should eql('Trimix 18/35')
    end
  end

  context "Heliox" do
    before { @mix = Mix.new 'Heliox', 18, 82, 0 }

    it "should be heliox 18/82" do
      @mix.to_s.should eql('Heliox 18/82')
    end
  end
end
