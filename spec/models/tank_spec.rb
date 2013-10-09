require 'spec_helper'

describe Tank do

  before { @tank = Tank.new }

  context "setting the mix contents before validation" do
    before do
      @tank.o2 = 77
      @tank.he = 11
      @tank.n2 = 99
      @tank.dive = Factory(:dive)
    end

    context "Air" do
      before do
        @tank.mix_type = 'Air'
      end

      it "should set for Air" do
        @tank.valid?
        @tank.o2.should eql(21.0)
        @tank.he.should eql(0.0)
        @tank.n2.should eql(79.0)
      end
    end

    context "Nitrox" do
      before do
        @tank.mix_type = 'Nitrox'
        @tank.o2 = 32
      end

      it "should set for nitrox" do
        @tank.valid?
        @tank.o2.should eql(32.0)
        @tank.he.should eql(0.0)
        @tank.n2.should eql(68.0)
      end
    end

    context "Trimix" do
      before do
        @tank.mix_type = 'Trimix'
        @tank.o2 = 21
        @tank.he = 40
      end

      it "should set for trimix" do
        @tank.valid?
        @tank.o2.should eql(21.0)
        @tank.he.should eql(40.0)
        @tank.n2.should eql(39.0)
      end
    end
  end

  context "Heliox" do
    before do
      @tank.o2 = 10
      @tank.he = 90
      @tank.mix_type = 'Heliox'
    end
    it "should set for heliox" do
      @tank.valid?
      @tank.o2.should eql(10.0)
      @tank.he.should eql(90.0)
      @tank.n2.should eql(0.0)
    end
  end
  it "should require dive_id" do
    @tank.should have(1).error_on(:dive_id)
  end


  context "valid contents" do
    before do
      @tank.he = 21
      @tank.o2 = 35
      @tank.n2 = 44
      @tank.mix_type = 'Trimix'
      @tank.valid?
    end

    it 'should have a tank mix type' do
      @tank.mix_type.should eql("Trimix")
    end

    it "should not have a contents error" do
      @tank.should have(0).errors_on(:mix)
    end
  end

  it "should respond to dive" do
    @tank.should respond_to(:dive)
  end


  context "nested_attributes_workaround" do

    context "with :nested" do
      before { @tank.nested  = true }

      it "should not require dive_id" do
        @tank.should have(0).errors_on(:dive_id)
      end
    end

    context "without :nested" do
      it "should require dive_id" do
        @tank.should have(1).error_on(:dive_id)
      end
    end
  end


  context "with a volume and volume_unit" do
     before { @tank = Factory(:tank, :volume => "80", :volume_unit => :imperial)}
       it 'should have a size.to_s' do
         @tank.size.to_s.should eql("80.0 cu. ft.")
       end
   end

   context "with a volume_unit but no volume" do
     before { @tank = Factory(:tank, :volume => nil, :volume_unit => :metric)}
       it 'should not have a size.to_s' do
         @tank.size.to_s.should be_blank
       end
   end


end
