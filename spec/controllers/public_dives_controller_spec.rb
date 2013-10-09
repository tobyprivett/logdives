require 'spec_helper'

describe PublicDivesController do
  render_views

  context "show not logged in user" do
    before { @dive = Factory.create(:dive, :diver => Factory(:another_user)) }

    it "should get the summary" do
      get "show", :id => @dive
      assigns[:dive].should eql(@dive)
      response.should render_template('show')
      response.should be_success
    end
  end


  context 'a logged in user ' do
    login_user

    it "viewing their own dive" do
      @dive = Factory.create(:dive, :diver => @user)
      get 'show', :id => @dive.id
      response.should redirect_to(edit_dive_path(@dive))
    end

    it "viewing another's dive" do
      @dive = Factory.create(:dive, :diver => Factory.create(:another_user))
      get 'show', :id => @dive.id
      assigns[:dive].should eql(@dive)
      response.should render_template('show')
      response.should be_success
    end

  end

  it "index" do
    @dives = [Factory.create(:dive, :diver => @user)]
    get 'index'
    response.should render_template('index')
    response.should be_success
  end

end
