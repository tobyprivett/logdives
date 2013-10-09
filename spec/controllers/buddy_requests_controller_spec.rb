require 'spec_helper'

describe BuddyRequestsController do
  render_views

  context 'logged in user' do
    login_user

    it 'index with a new_buddy_request redirects to show' do
      @buddy = Factory.create(:buddy)
      controller.current_user.stub!(:new_buddy_requests).and_return([@buddy])
      get :index
      response.should redirect_to(buddy_request_path(@buddy))
    end

    it 'index with no new_buddy_requests redirects to buddy_confirmations' do
      controller.current_user.stub!(:new_buddy_requests).and_return([])
      get :index
      response.should redirect_to(buddy_confirmations_path)
    end

    it 'shows' do
      setup_buddy
      get 'show', :id => @buddy
      assigns[:buddy].should be_present
      assigns[:dive].should be_present
      response.should be_success
      response.should render_template('show')
    end
  end

  context 'not logged in' do
    it "comes from the email link" do
      setup_buddy
      controller.should_receive(:sign_in).with(@buddy_diver)
      get 'gateway', :id => @buddy
      assigns[:buddy].should be_present
      assigns[:dive].should be_present
      response.should be_success
      response.should render_template('show')
    end

    it "comes from the email link: FAILURE" do
      controller.should_not_receive(:sign_in)
      @buddy = Factory.create(:buddy)
      get 'gateway', :id => @buddy
      response.should redirect_to(buddy_confirmations_path)
    end
  end

end

def setup_buddy
  @dive = Factory.create(:dive, :diver => Factory.create(:yet_another_user))
  @buddy_diver = Factory.create(:another_user)
  @buddy = Factory.create(:buddy_awaiting_confirmation, :dive => @dive, :buddy_diver => @buddy_diver)
end