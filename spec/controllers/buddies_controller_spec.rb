require 'spec_helper'

describe BuddiesController do
  render_views
  login_user

  context "processing a buddy confirmation request" do

    it "should request confirmation" do
      @dive = Factory.create(:dive, :diver => @user)
      @buddy = Factory.create(:buddy, :dive => @dive, :buddy_diver => Factory(:another_user))

      post 'request_confirmation', :id => @buddy
      assigns[:buddy].should be_awaiting_confirmation
      response.should render_template('request_confirmation')
      response.should be_success
    end


    it "should request confirmation (js)" do
      @dive = Factory.create(:dive, :diver => @user)
      @buddy = Factory.create(:buddy, :dive => @dive, :buddy_diver => Factory(:another_user))

      post 'request_confirmation', :id => @buddy, :format => 'js'
      assigns[:buddy].should be_awaiting_confirmation
      response.should render_template('request_confirmation')
      response.should be_success
    end

    it "should throw Record Not Found" do
      @dive = Factory.create(:dive, :diver => @another_user)
      @buddy = Factory.create(:buddy, :dive => @dive)

      lambda {post 'request_confirmation', :id => @buddy}.should raise_error(ActiveRecord::RecordNotFound)
    end


    context "and a buddy" do
      before do
        @dive = Factory.create(:dive, :diver => @user)
        @buddy = Factory.create(:buddy, :dive => @dive)
      end

      it "should delete the buddy" do
        put :destroy, :id => @buddy.id
        flash[:notice].should =~ /Buddy deleted/
        response.should redirect_to(edit_dive_path(@buddy.dive))
      end
    end
  end

end
