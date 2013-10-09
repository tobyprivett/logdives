require 'spec_helper'

describe DivesHelper do
  context 'with a Buddy' do
    before { @buddy = Factory(:buddy) }

    it "should have a delete link" do
      link = link_to_delete_buddy(@buddy)
      link.should =~ /sure you want to remove this person/
    end
  end

  context "visibililty" do

    it 'should set for true' do
      off_state(true).should eql({:style => 'display:none'})
      on_state(true).should eql({:style => ''})
    end

    it 'should set for false' do
      off_state(false).should eql({:style => ''})
      on_state(false).should eql({:style => 'display:none'})
    end

    it "should link_to_show" do
      link_to_show('buddy').should eql("<a href=\"#\" class=\"mini-link\" id=\"show_buddy\">show</a>")
    end

    it "should link_to_hide" do
      link_to_hide('buddy').should eql("<a href=\"#\" class=\"mini-link\" id=\"hide_buddy\">hide</a>")
    end
  end
end