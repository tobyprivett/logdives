require 'spec_helper'

describe DivesController do
  render_views
  login_user


  context 'getting new' do
    before do
      @dive = Factory(:dive, :diver => @user, :template => 'tec')
      Dive.should_receive(:init_with_diver).with(@user).and_return(@dive)
    end

    it 'gets with no template if should use previous template'  do
      get 'new'
      assigns[:dive].template.should eql(@dive.template)
      response.should render_template('new')
      response.should be_success
    end


    it 'gets with tec template'  do
      get 'new', :template => 'tec'
      assigns[:dive].template.should eql('tec')
      response.should render_template('new')
      response.should be_success
    end
  end

  it "creates" do
    post 'create', valid_params_with_empty_nested_attributes
    flash[:notice].should =~ /added to your log/
    response.should redirect_to(edit_dive_path(assigns[:dive]))
  end

  it "doesn't create" do
    post 'create', invalid_params_with_empty_nested_attributes
    assigns[:dive].template.should eql('tec')
    response.should render_template('new')
    response.should be_success
  end

  it "edits" do
    @dive = Factory.create(:dive, :diver => @user)
    get 'edit', :id => @dive.id
    assigns[:dive].should eql(@dive)
    response.should render_template('edit')
    response.should be_success
  end



  it "index with a dive" do
    Factory.create(:dive, :diver => @user)
    get 'index'
    assigns[:dives].should be_present
    response.should render_template('index')
  end

  it "index without a dive" do
    get 'index'
    response.should redirect_to(new_dive_path)
  end

  it "updates" do
    @dive = Factory.create(:dive, :diver => @user)
    put 'update', :id => @dive.id, :dive => {:location => 'Cool dive site'}
    response.should redirect_to(edit_dive_path(assigns[:dive]))
  end

  it "updates with buddy params (that were breaking)" do
    @dive = Factory.create(:dive, :diver => @user)
    @buddy = Factory.create(:buddy, :dive => @dive, :role => nil)
    put 'update', :id => @dive.id, :dive =>{"buddy_visible"=>"1", "buddies_attributes"=>{"0"=>{"nested"=>"", "role"=>"Instructor", "id"=> @buddy.id}}}
    assigns[:dive].should eql(@dive)
    assigns[:dive].buddies.first.role.should eql("Instructor")
  end


  it "updates with tank params (that were breaking)" do
    @dive = Factory.create(:dive, :diver => @user)
    @tank = Factory.create(:tank, :dive => @dive)
    put 'update', :id => @dive.id, :dive => {"tanks_attributes" => {"id" => @tank.id, "nested"=>"", "start_pressure"=>"200"}}
    assigns[:dive].should eql(@dive)
    assigns[:dive].tanks.first.start_pressure.should eql(200)
  end

  it "doesn't update" do
    @dive = Factory.create(:dive, :diver => @user)
    put 'update', :id => @dive.id, :dive => {:location => nil}
    assigns[:dive].should eql(@dive)
    response.should render_template('edit')
  end


  it 'deletes' do
    @dive = Factory.create(:dive, :diver => @user)
    put 'destroy', :id => @dive.id
    flash[:notice].should =~ /deleted/
    response.should redirect_to(dives_path)
  end
end


def valid_params_with_empty_nested_attributes
  {"dive" => {"dive_date"=>"10/05/2011 00:00", "total_dive_time"=>"", "max_depth_amount"=>"", "depth_unit"=>"metric", "location"=>"Abu Helal, Dahab", "buddies_attributes"=>{"0"=>{"nested"=>"", "email"=>"", "role"=>""}, "1"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "2"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "3"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "4"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "5"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "6"=>{"nested"=>"deleted", "email"=>"", "role"=>""}}, "waypoints_attributes"=>{"0"=>{"nested"=>"", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "1"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "2"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "3"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "4"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "5"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "6"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "7"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "8"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}}, "tanks_attributes"=>{"0"=>{"nested"=>"", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "1"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric", "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "2"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "3"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "4"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric", "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "5"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "6"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",   "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "7"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}}, "condition_ids"=>[""], "exposure_suit_ids"=>[""], "notes"=>""}, "dive_buddy_count"=>"1", "dive_waypoint_count"=>"1", "dive_tank_count"=>"2"}
end

def invalid_params_with_empty_nested_attributes
  {"dive"=>{"template" => 'tec', "dive_date"=>"", "total_dive_time"=>"", "max_depth_amount"=>"", "depth_unit"=>"metric", "location"=>"", "buddies_attributes"=>{"0"=>{"nested"=>"", "email"=>"", "role"=>""}, "1"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "2"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "3"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "4"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "5"=>{"nested"=>"deleted", "email"=>"", "role"=>""}, "6"=>{"nested"=>"deleted", "email"=>"", "role"=>""}}, "waypoints_attributes"=>{"0"=>{"nested"=>"", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "1"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "2"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "3"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "4"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "5"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "6"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "7"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}, "8"=>{"nested"=>"deleted", "time"=>"", "depth_amount"=>"", "depth_unit"=>"metric", "name"=>""}}, "tanks_attributes"=>{"0"=>{"nested"=>"", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "1"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "2"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "3"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "4"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "5"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "6"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}, "7"=>{"nested"=>"deleted", "start_pressure"=>"", "end_pressure"=>"", "pressure_unit"=>"metric",  "o2"=>"21.0", "he"=>"0.0", "mix_type"=>"Air"}}, "condition_ids"=>[""], "exposure_suit_ids"=>[""], "notes"=>""}, "dive_buddy_count"=>"1", "dive_waypoint_count"=>"1", "dive_tank_count"=>"1"}
end

