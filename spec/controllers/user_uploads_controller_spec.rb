require 'spec_helper'

describe UserUploadsController do
  render_views
  login_user

  it "gets new" do
    get 'new'
    assigns[:user_upload].should be_present
    response.should render_template('new')
  end

  it "doesn't create" do
    post :create, :user_upload => 'invalid attrs'
    response.should render_template('new')
  end

end
