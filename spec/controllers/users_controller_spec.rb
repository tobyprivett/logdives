require 'spec_helper'

describe UsersController do
  login_user
  render_views

  it 'updates name' do
      put 'update', :id => @user.id, :user => {:name_accessor => 'Toby 1'}
      response.should redirect_to(preferences_path)
      flash[:notice].should =~ /Your account has been updated/
  end

  it 'fails to update' do
      controller.stub!(:current_user).and_return(@user)
      @user.stub!(:update_attributes => false)
      controller.current_user.should_receive(:reload)
      put 'update', :id => @user.id, :user => {:name_accessor => 'Toby 1'}
      response.should render_template('preferences/show')
  end

  context "get index (js)" do
    before { @users = [Factory.create(:another_user)]}

    it "should get without params" do
      User.should_receive(:limit).with(100).and_return(@users)
      get 'index', :format => :js
      response.should render_template('index')
    end

    it "should get with search params" do
      User.should_receive(:all).and_return(@users)
      get 'index', :format => :js, :term => 'Joe'
      response.should render_template('index')
    end
  end


  context "get index (html)" do
    it "should redirect" do
      get 'index'
      response.should redirect_to(root_path)
    end
  end
end
