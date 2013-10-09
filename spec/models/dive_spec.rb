require 'spec_helper'

describe Dive do


  context "validations and associations" do
    before { @dive = Dive.new }

    it "should respond to waypoints" do
      @dive.should respond_to(:waypoints)
    end

    it "should require a dive_date" do
      @dive.should have(1).error_on(:dive_date)
    end

    it "should respond to confirmed_buddies" do
      @dive.should respond_to(:confirmed_buddies)
    end

    it 'should have a default template' do
      @dive.template.should eql('rec')
    end

    it "should require a location" do
      @dive.should have(1).error_on(:location)
    end

    it "should respond to diver" do
      @dive.should respond_to(:diver)
    end

    it "should require a location" do
      @dive.should have(1).error_on(:location)
    end

    it "should respond to exposure suits" do
      @dive.should respond_to(:exposure_suits)
    end

    it "should respond to dives" do
      @dive.should respond_to(:conditions)
    end


    it "should set buddy_visible" do
      @dive.buddy_visible?.should be_true
    end

    it "should set profile_visible" do
      @dive.profile_visible?.should be_true
    end

    it "should set photos_visible" do
      @dive.photos_visible?.should be_true
    end


    it "should respond to tanks_visible" do
      @dive.tanks_visible?.should be_true
    end


    it "should set equipment_visible" do
      @dive.equipment_visible?.should be_true
    end


    it "should set conditions_visible" do
      @dive.conditions_visible?.should be_true
    end

    it "should set default rating" do
      @dive.rating.should eql(0)
    end

    it "should respond to :tanks" do
      @dive.should respond_to(:tanks)
    end

    context "weight" do
      before do
        @dive.weight_amount = 6
        @dive.weight_unit = :metric
      end

      it "should have an imperial weight string" do
        @dive.weight.to_s(:imperial).should eql("13.2 lb")
      end

      it "should have a metric weight string" do
        @dive.weight.to_s(:metric).should eql("6.0 kg")
      end
    end


    context 'max depth and time' do
      before { @dive = Dive.new }

      it 'should return an empty string' do
        @dive.max_depth_and_time(:metric).should be_blank
      end

      context 'with a depth' do
        before { @dive.max_depth_amount = 50 }

        it 'should return 50m' do
          @dive.max_depth_and_time(:metric).should eql('50.0 m')
        end

        context 'with a time' do
          before { @dive.total_dive_time = 90 }

          it 'should return 50m / 90mins' do
            @dive.max_depth_and_time(:metric).should eql('50.0 m / 90 mins')
          end
        end
      end
    end

    context "editability" do
      before do
        @user ||= Factory(:user)
        @another_user ||= Factory(:another_user)
        @dive.diver = @user
      end

      it 'should be editable_by @user' do
        @dive.editable_by?(@user).should be_true
      end

      it 'should not be editable by another_user' do
        @dive.editable_by?(@another_user).should be_false
      end

    end

    context "temperature" do
      before do
        @dive.air_temperature = 18
        @dive.water_temperature_at_depth = 12
        @dive.water_temperature_on_surface = 15
        @dive.temperature_unit = :metric
      end

      it "should have metric temperatures" do
        @dive.air_temp.to_s(:metric).should eql("18.0 #{Temperature.deg_c}")
        @dive.water_temp_depth.to_s(:metric).should eql("12.0 #{Temperature.deg_c}")
        @dive.water_temp_surface.to_s(:metric).should eql("15.0 #{Temperature.deg_c}")
      end

      it "should have imperial temperatures" do
        @dive.air_temp.to_s(:imperial).should eql("64.4 #{Temperature.deg_f}")
        @dive.water_temp_depth.to_s(:imperial).should eql("53.6 #{Temperature.deg_f}")
        @dive.water_temp_surface.to_s(:imperial).should eql("59.0 #{Temperature.deg_f}")
      end
    end
  end

  context "setting dive numbers for multiple dives" do
    before do
      @user = Factory(:user)
      @dive_1 = Factory.create(:dive, :diver => @user, :dive_date => 2.days.ago)
      @dive_2 = Factory.create(:dive, :diver => @user,  :dive_date => 1.day.ago)
    end

    it "should add a dive number " do
      Dive.find(@dive_1).dive_no.should_not be_nil
    end

    it "should not change the dive number on_update" do
      orig_dive_number = Dive.find(@dive_2).dive_no
      @dive_2.update_attribute :location, "another place"
      Dive.find(@dive_2).dive_no.should eql(orig_dive_number)
    end

  end

  context "with samples" do
    before { @dive = Dive.new }

    before do
      @dive.samples = dive_samples
    end

    it "should have a profile image" do
      @dive.profile_image_url.should be_present
    end

    it "should have a adjusted_y" do
      @dive.adjusted_y.should eql([35.0, 21.34, 10.73, 0.4299999999999997, 9.510000000000002, 19.21, 29.21, 35.0])
    end

    it "should have x_samples" do
      @dive.x_samples.should eql([0, 1, 2, 3, 4, 5, 6, 7])
    end

    it "should have y_samples" do
      @dive.y_samples.should eql([0, 13.66, 24.27, 34.57, 25.49, 15.79, 5.79, 0])
    end

    it "should have x_samples" do
      @dive.x_samples.should eql([0, 1, 2, 3, 4, 5, 6, 7])
    end

    it "should have x_axis_range" do
      @dive.x_axis_range.should eql([0, 10, 5])
    end

    it "should have y_axis_range" do
      @dive.y_axis_range.should eql([35.0, 0, -5])
    end


    it "should have axis_range" do
      @dive.axis_range.should eql([[0, 10, 5], [35.0, 0, -5]])
    end

    it "should have max_y_rounded" do
      @dive.max_y_rounded.should eql(35.0)
    end
  end

  context "without samples" do
    before { @dive = Dive.new }

    before do
      @dive.samples = nil
    end
    it "should not have a profile image" do
      @dive.profile_image_url.should_not be_present
    end
  end


  context "init with diver (no previous dives)" do
    before do
      @user = Factory.create(:user)
      @dive = Dive.init_with_diver(@user)
    end

    it "should use the default template" do
      @dive.template.should eql('rec')
    end

    it "should set the dive no to 1" do
      @dive.dive_no.should eql(1)
    end
  end

  context 'deleting a dive' do
    before do
      @dive = Factory.create(:dive)
      @dive_id = @dive.id
      @buddy_diver = Factory.create(:another_user)
      @buddy = Factory.create(:buddy_awaiting_confirmation, :dive => @dive, :buddy_diver => @buddy_diver)
      @cloned_dive = Dive.reciprocate_for_buddy!(@buddy)
      @dive.destroy
    end

    it 'should remove reciprocal dive id from buddy' do
      Buddy.where(:reciprocal_dive_id => @dive_id).should be_empty
    end
  end


  context "cloning for a buddy" do
    before do
      @dive = Factory.create(:dive, :total_dive_time => 100, :max_depth_amount => 140, :average_depth_amount => 111, :depth_unit => :imperial)
      @buddy_diver = Factory.create(:another_user)
      @buddy = Factory.create(:buddy_awaiting_confirmation, :dive => @dive, :buddy_diver => @buddy_diver)
      @cloned_dive = Dive.reciprocate_for_buddy!(@buddy)
    end

    context 'trying to clone again' do
      before { @another_cloned_dive = Dive.reciprocate_for_buddy!(@buddy) }

      it 'should return the original cloned_dive (and not another new dive)' do
        @another_cloned_dive.should eql(@cloned_dive)
      end
    end

    it "should set the location" do
      @cloned_dive.location.should eql(@dive.location)
    end

    it "should confirm the first buddy" do
      @cloned_dive.buddies.first.should be_confirmed
    end


    it "should only create one buddy" do
      @cloned_dive.buddies.first.should be_confirmed
    end

    it "should set the reciprocal_dive of the buddy's cloned dive to the original" do
      @cloned_dive.buddies.first.reciprocal_dive.should eql(@dive)
    end


    it "should update the original buddy.reciprocal_dive_id with the new dive id" do
      @buddy.reload
      @buddy.reciprocal_dive_id.should eql(@cloned_dive.id)
    end

    it "should set total dive time" do
      @cloned_dive.total_dive_time.should eql(100)
    end

    it "should set max depth" do
      @cloned_dive.max_depth.to_s.should eql("140.0 ft")
    end

    it "should set average depth" do
      @cloned_dive.average_depth.to_s.should eql("111.0 ft")
    end

    it "should have a dive_no" do
      @cloned_dive.dive_no.should_not be_nil
    end

  end


  context "init with defaults (metric)" do
    before { @dive = Dive.init_with_units(:metric) }

    it "should set defaults" do
      @dive.depth_unit.should eql(:metric)
      @dive.temperature_unit.should eql(:metric)
      @dive.weight_unit.should eql(:metric)
      @dive.tanks.first.pressure_unit.should eql(:metric)
      @dive.waypoints.first.depth_unit.should eql(:metric)
      @dive.waypoints.length.should eql(1)
    end

  end

  context "init with defaults (imperial)" do
    before { @dive = Dive.init_with_units(:imperial) }

    it "should set defaults" do
      @dive.depth_unit.should eql(:imperial)
      @dive.temperature_unit.should eql(:imperial)
      @dive.weight_unit.should eql(:imperial)
      @dive.tanks.first.pressure_unit.should eql(:imperial)
      @dive.waypoints.first.depth_unit.should eql(:imperial)
      @dive.waypoints.length.should eql(1)
    end
  end

  context "init with diver" do
    before do
      @user = Factory.create(:user, :units => :imperial, :name => 'The diver')
      @previous_dive = Factory(:dive, :diver => @user)
      @previous_dive.tanks_visible = true
      @previous_dive.template = 'tec'
      @previous_dive.buddy_visible = false
      @previous_dive.profile_visible = false
      @previous_dive.photos_visible = true
      @previous_dive.equipment_visible = false
      @previous_dive.conditions_visible = false
      @previous_dive.notes_visible = false

      @previous_dive.tanks << Factory(:trimix_tank_18_35_imperial)
      @previous_dive.tanks << Factory(:deco_tank_metric)
      @previous_dive.save!
      @user.reload

      @dive = Dive.init_with_diver(@user)
    end

    it "should have a diver_name" do
      @dive.diver_name.should eql('The diver')
    end

    it "should increment the dive no" do
      @dive.dive_no.should eql(@previous_dive.dive_no + 1)
    end

    it "should set the template visibility correctly" do
      @dive.template.should eql('tec')
      @dive.tanks_visible.should be_true
      @dive.buddy_visible.should be_false
      @dive.profile_visible.should be_false
      @dive.photos_visible.should be_true
      @dive.equipment_visible.should be_false
      @dive.conditions_visible.should be_false
      @dive.notes_visible.should be_false
    end

    it "should clone 3 tanks" do
      @dive.tanks.length.should eql(2)
    end

    it "should clone the tank details" do

      @dive.tanks[0].mix.to_s.should eql("Trimix 18/35")
      @dive.tanks[0].pressure_unit.to_sym.should eql(:imperial)
      @dive.tanks[0].o2.should eql(18.0)
      @dive.tanks[0].he.should eql(35.0)
      @dive.tanks[0].n2.should eql(47.0)
      @dive.tanks[0].volume.should eql("108")
      @dive.tanks[0].volume_unit.to_sym.should eql(:imperial)

      @dive.tanks[1].mix.to_s.should eql("Nitrox 80")
      @dive.tanks[1].pressure_unit.to_sym.should eql(:metric)
      @dive.tanks[1].o2.should eql(80.0)
      @dive.tanks[1].he.should eql(0.0)
      @dive.tanks[1].n2.should eql(20.0)
      @dive.tanks[1].volume.should eql("6")
      @dive.tanks[1].volume_unit.to_sym.should eql(:metric)
    end

  end

  context "saving with a tank" do
    before do
      @dive = Factory.create(:dive)
      @dive.tanks << Factory.create(:tank)
      @dive.save!
    end

    it 'should have one tank' do
      @dive.tanks.length.should eql(1)
    end

    context "marking as deleted" do
      before do
        @dive.tanks.map {|tank| tank.nested = 'deleted'}
        @dive.save!
        @dive.reload
      end

      it "should remove the tank" do
        @dive.tanks.length.should eql(0)
      end
    end
  end

  context "saving with a waypoint" do
    before do
      @dive = Factory.create(:dive)
      @dive.waypoints << Factory.create(:waypoint)
      @dive.save!
    end

    it 'should have one waypoint' do
      @dive.waypoints.length.should eql(1)
    end

    context "marking as deleted" do
      before do
        @dive.waypoints.map {|waypoint| waypoint.nested = 'deleted'}
        @dive.save!
        @dive.reload
      end

      it "should remove the waypoint" do
        @dive.waypoints.length.should eql(0)
      end
    end
  end

  context "saving with a buddy" do
    before do
      @dive = Factory.create(:dive)
      @dive.buddies << Factory.create(:buddy)
      @dive.save!
    end

    it 'should have one buddy' do
      @dive.buddies.length.should eql(1)
    end

    context "marking as deleted" do
      before do
        @dive.buddies.map {|buddy| buddy.nested = 'deleted'}
        @dive.save!
        @dive.reload
      end

      it "should remove the buddy" do
        @dive.buddies.length.should eql(0)
      end
    end
  end

  context 'creating with a location that is a friendly_id reserved word' do
    before do
      @reserved_word = 'New'
      @dive = Factory.create(:dive, :location => @reserved_word)
    end

    it 'should create a cached_slug' do
      @dive.cached_slug.should =~ /101-new/
    end
  end



  context "creating a dive with a new dive site" do
    before { @dive = Factory.create(:dive, :location => 'My new dive site')}

    it 'should create a dive site record' do
      DiveSite.last.name.should eql('My new dive site')
    end

    it 'should associate dive site with a the diver' do
      DiveSite.last.added_by.should eql(@dive.diver)
    end
  end

end


def dive_samples
  [["60", "13.66"], ["120", "24.27"], ["180", "34.57"], ["240", "25.49"], ["300", "15.79"], ["360", "5.79"]]
end
