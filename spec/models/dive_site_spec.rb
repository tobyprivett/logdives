require 'spec_helper'

describe DiveSite do

  context 'in general' do
    before { @dive_site = DiveSite.new }

    it 'should require a name' do
      @dive_site.should have(1).error_on(:name)
    end

  end

  context 'setting the name' do
    before { @user = Factory.create(:user) }
    context 'site, location' do
      before { @dive_site = DiveSite.diver_added('Gran Cenote, Mexico', @user) }

      it 'should set the site' do
        @dive_site.site.should eql('Gran Cenote')
      end

      it 'should set the location' do
        @dive_site.location.should eql('Mexico')
      end
    end

    context 'site only' do
      before { @dive_site = DiveSite.diver_added('Gran Cenote', @user) }

      it 'should set the site' do
        @dive_site.site.should eql('Gran Cenote')
      end

      it 'should set the location' do
        @dive_site.location.should be_blank
      end
    end

    context 'existing site' do
      before do
        DiveSite.create :site => 'Gran Cenote'
        @dive_site_count = DiveSite.count
        @dive_site = DiveSite.diver_added('Gran Cenote', @user)
      end

      it 'should not add another site' do
        DiveSite.count.should eql(@dive_site_count)
      end
    end
  end

  context 'building the name from both attributes' do
    before do
      @dive_site = DiveSite.new :site => 'Blue Hole', :location => 'Dahab'
    end

    it 'should have a name' do
      @dive_site.name.should eql('Blue Hole, Dahab')
    end
  end

  context 'building the name from site only' do
    before do
      @dive_site = DiveSite.new :site => 'Blue Hole', :location => ''
    end

    it 'should have a name' do
      @dive_site.name.should eql('Blue Hole')
    end
  end


  context 'building the name from location only' do
    before do
      @dive_site = DiveSite.new :site => '', :location => 'Dahab'
    end

    it 'should have a name' do
      @dive_site.name.should eql('Dahab')
    end
  end
end
