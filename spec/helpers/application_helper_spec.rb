require 'spec_helper'


describe ApplicationHelper do


  context "displaying time" do
    it "should display time in minutes" do
      minutes(10).should eql('10 minutes')
    end

    it "should display nothing" do
      minutes(0).should be_blank
    end
  end

  context "dive profile images:" do
    before {  @dive = Factory(:dive) }

    context "with" do
      before { @dive.stub!(:profile_image_url).and_return('a_profile_image.png') }

      it "should render the profile image partial" do
        dive_profile_image(@dive).should include('src="/images/a_profile_image.png"')
      end
    end

    context "without" do
      before{ @dive.stub!(:profile_image_url).and_return(nil) }

      it "should render the profile image partial" do
        dive_profile_image(@dive).should be_nil
      end
    end
  end

  context "obfuscating name when name == email" do

    before do
      @another_user = Factory(:another_user, :name => 'email@example.com', :email => 'email@example.com')
      self.stub!(:current_user).and_return(User.new)
      self.stub!(:user_signed_in?).and_return(true)
    end

    it 'should return anon' do
      obfuscate_name(@another_user).should =~ /anon/
    end
  end

  context "not obfuscating name when name != email" do
    before do
      @another_user = Factory(:another_user, :name => 'myname', :email => 'email@example.com')
    end

    it 'should return anon' do
      obfuscate_name(@another_user).should =~ /myname/
    end
  end

  context 'not obfuscating name when another_user is a friend of the user' do
    login_user

    before do
      @another_user = Factory(:another_user, :name => 'email@example.com', :email => 'email@example.com')
      @user.stub!(:friends).and_return([@another_user])
      self.stub!(:current_user).and_return(@user)
      self.stub!(:user_signed_in?).and_return(true)
    end

    it 'should display the email address' do
      obfuscate_name(@another_user).should =~ /email@example.com/
    end
  end

  context "not obfuscating name" do
    before { @user = Factory(:user, :name => 'a username', :email => 'email@example.com') }

    it 'should return anon' do
      obfuscate_name(@user).should =~ /a username/
    end
  end

end