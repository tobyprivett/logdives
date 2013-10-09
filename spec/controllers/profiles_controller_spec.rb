require 'spec_helper'

describe ProfilesController do
  render_views
  login_user

  it 'should show the profile of another user' do
    @another_user = Factory.create(:another_user)
    get 'show', :id => @another_user
    assigns[:user].should eql(@another_user)
    assigns[:dives].should_not be_nil
    response.should render_template('show')
    response.should be_success
  end

  it 'should show redirect user viewing their own profile to my dives' do
     get 'show', :id => @user
     response.should redirect_to(dives_path)
   end


  it 'should NOT be allowed to edit a profile' do
    @another_user = Factory.create(:another_user)
    get 'edit', :id => @another_user
    response.should redirect_to(profile_path(@another_user))
  end

  it 'should edit a profile' do
    get 'edit', :id => @user
    assigns[:user].should eql(@user)
    response.should render_template('edit')
    response.should be_success
  end

  it 'should update a profile and redirect' do
    put 'update', :id => @user, :user => {:bio => 'stuff about me'}
    response.should redirect_to(dives_path)
  end
end
