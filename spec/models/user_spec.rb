require 'spec_helper'

describe User do


  context "validations and associations" do
    before { @user = User.new }


    it "should respond to dives" do
      @user.should respond_to(:dives)
    end

    it "should require name and length" do
      @user.should have(2).errors_on(:name)
    end

    it "should respond to buddies" do
      @user.should respond_to(:buddies)
    end

    it "should respond to user_uploads" do
      @user.should respond_to(:user_uploads)
    end

    it "should have a default log_start_no" do
      @user.log_start_no.should eql(1)
    end

    it "should respond to buddy_confirmations" do
      @user.should respond_to(:buddy_confirmations)
    end

    it 'should have a mini avatar' do
      @user.avatar.url.should eql("http://logdives.com/images/fallback/default.gif")
    end
  end

  context 'friendship' do
    before do
      @user = Factory(:user)
      @dive = Factory(:dive, :diver => @user)
      @another_user = Factory(:another_user)
      @buddy = Factory(:buddy, :dive => @dive, :buddy_diver => @another_user)
    end

    it 'should make @user friends with @another_user' do
      @user.friends.should include(@another_user)
    end
  end


  context "creating by email address - new user" do
    before do
      @user = User.find_or_create_without_password!('email@example.com')
    end

    it "should be saved" do
      @user.should_not be_new_record
    end

    it 'should populate the reset password token' do
      @user.reset_password_token.should be_present
    end

    it 'should be confirmed (devise)' do
      @user.should be_confirmed
    end

    it "should assign the name" do
      @user.name.should eql('email@example.com')
    end
  end

  context "creating by email address - existing user" do
    before do
      @user = User.find_or_create_without_password!('email@example.com')
      @same_user = User.find_or_create_without_password!('email@example.com')
    end

    it "should return original user" do
      @same_user.should eql(@user)
    end
  end

  context "log nos" do
    before do
      dive = Factory.create(:dive)
      @user = dive.diver
      @user.update_attribute :log_start_no, 1100
      @user.set_log_start_no!
    end

    it "should reset_dive_nos" do
      @user.dives.first.dive_no.should eql(1100)
    end
  end

  context "new requests counter" do
    before do
      @user = Factory(:user)
      @buddy = Factory(:buddy_awaiting_confirmation, :buddy_diver => @user)
    end

    it 'should have one buddy_confirmation' do
      @user.new_buddy_requests.length.should eql(1)
    end

    it "should have a new_requests_count of 1" do
      @user.new_buddy_requests_count.should eql(1)
    end
  end

end
