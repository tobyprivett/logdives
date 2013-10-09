require 'spec_helper'

describe BuddyConfirmationsController do
  render_views
  login_user

   before do
      @dive = Factory.create(:dive, :diver => Factory.create(:yet_another_user))
      @buddy_diver = Factory.create(:another_user)
      @buddy = Factory.create(:buddy_awaiting_confirmation, :dive => @dive, :buddy_diver => @buddy_diver)
    end

  context "buddy is awaiting confirmation" do


    context "on the confirmation page" do
      it "should confirm" do
        put :update, :id => @buddy
        assigns[:buddy].should be_confirmed
        response.should redirect_to(buddy_confirmation_path(@buddy))
      end

      it "should reject" do
        put :destroy, :id => @buddy
        assigns[:buddy].should be_rejected
        response.should redirect_to(buddy_confirmation_path(@buddy))
      end
    end
  end

  context "buddy is confirmed" do
    before { @buddy.confirm! && @buddy.save! }
    it "should clone the dive" do
      Dive.should_receive(:reciprocate_for_buddy!).with(@buddy)
      post :clone_buddy, :id => @buddy
      response.should redirect_to(buddy_confirmation_path(@buddy))
    end
  end


  context "buddy is rejected" do
    before { @buddy.reject! && @buddy.save! }
    it "should confirm the dive" do
      post :update, :id => @buddy
      assigns[:buddy].should be_confirmed
      response.should redirect_to(buddy_confirmation_path(@buddy))
    end
  end


  context "viewing a list of buddy confirmation requests" do
    it "should get the index page " do
      @buddies = [Factory(:buddy)]
      controller.current_user.stub!(:claimed_buddies).and_return(@buddies)
      get :index
      assigns[:buddies].should_not be_nil
      response.should render_template('index')
    end

  end
end
