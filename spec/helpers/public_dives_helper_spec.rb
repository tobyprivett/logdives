require 'spec_helper'

describe PublicDivesHelper do
  context 'with a dive' do
    before { @dive = Factory(:dive) }

    it 'sould have a dive assets link' do
      @dive.stub!(:active_assets).and_return(['buddies', 'equipment'])
      link_to_dive_assets(@dive).should eql(link_to @dive.active_assets.join(", "), viewer_path(@dive), :id => "dive_assets_#{@dive.id}", :class => 'show-dive-assets')
    end
  end
end