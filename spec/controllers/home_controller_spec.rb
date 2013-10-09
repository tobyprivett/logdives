require 'spec_helper'

describe HomeController do
  render_views

  context "logged in" do
    login_user
    it "should redirect to my dives / new dive" do
      get 'show'
      response.should be_redirect
    end
  end

  context "not logged in" do
    it "should render redirect to sign in" do
      get 'show'
      response.should redirect_to('/latest')
    end
  end
end
