require 'spec_helper'

describe UserUpload do
  before do
    @user_upload = UserUpload.new
    @user = Factory.create(:user)
  end

  context "in general" do

    it "should respond to user" do
      @user_upload.should respond_to(:user)
    end

    it "should respond to dives" do
      @user_upload.should respond_to(:dives)
    end

    it "should require a file" do
      @user_upload.should have(1).error_on(:file)
    end
  end

  context "when saving with a valid file" do
    before do
      mock_file = mock_model('MockFile', :current_path => 'path/to/file')
      @user_upload.stub!(:file).and_return(mock_file)

      @user_upload.user = @user

      dive = Factory.create(:dive, :diver => @user)
      @dives = [dive]

      DiveImporter.should_receive(:import).and_return(@dives)
      @user_upload.save!
    end

    it "should assign dives" do
      @user_upload.dives.length.should eql(@dives.length)
    end

    it "should assign dives to the user_upload object" do
      @user_upload.dives.should eql(@dives)
    end

    it "should assign dives to the user object" do
      @user.dives.each do |dive|
        @dives.should include(dive)
      end
    end
  end

  context "when saving with an invalid file" do
    before do
      mock_file = mock_model('MockFile', :current_path => 'path/to/file')
      @user_upload.stub!(:file).and_return(mock_file)
      DiveImporter.should_receive(:import).and_return(nil)
      @user_upload.save
    end

    it "should not create dives" do
      @user_upload.dives.should be_empty
    end
  end

end
