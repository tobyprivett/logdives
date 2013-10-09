require 'spec_helper'

describe DiveSitesController do
  render_views

  context "get index" do
    before { @dive_sites = [Factory.create(:dive_site)]}

    it "should get without params" do
      DiveSite.should_receive(:limit).with(100).and_return(@dive_sites)
      get 'index'
      response.should render_template('index')
    end

    it "should get with search params" do
      DiveSite.should_receive(:all).and_return(@dive_sites)
      get 'index', :term => 'Dahab'
      response.should render_template('index')
    end
  end

  context "get new" do
    it "should render" do
      get 'new'
      assigns[:dive_site].should be_present
      response.should render_template('new')
      response.should be_success
    end
  end

  context 'creating' do
    it 'should create' do
      post 'create', :dive_site => {:name => 'Cenote Calimba'}
      assigns[:dive_site].should be_present
    end
  end

end
