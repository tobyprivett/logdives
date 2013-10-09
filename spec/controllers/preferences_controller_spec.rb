require 'spec_helper'

describe PreferencesController do
  login_user
  render_views

  it "shows" do
    get 'show'
    assigns[:user].should eql(@user)
    response.should render_template('show')
    response.should be_success
  end

end
