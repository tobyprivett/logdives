require 'spec_helper'

describe Buddy do

  context "in general" do
    before { @buddy = Buddy.new }

    it "should respond to diver" do
      @buddy.should respond_to(:diver)
    end

    it "should respond to dive" do
      @buddy.should respond_to(:dive)
    end


    it "should respond to buddy_diver_name_accessor" do
      @buddy.should respond_to(:buddy_diver_name_accessor)
    end

    it "should respond to buddy_diver" do
      @buddy.should respond_to(:buddy_diver)
    end

    context "nested_attributes_workaround" do
      context "with :nested" do
        before { @buddy.nested  = true }

        it "should not require dive_id" do
          @buddy.should have(0).errors_on(:dive_id)
        end
      end

      context "without :nested" do
        it "should require dive_id" do
          @buddy.should have(1).error_on(:dive_id)
        end
      end
    end
  end

  context 'sending a send_confirmation_request' do
    before do
      @buddy = Factory.create(:buddy, :buddy_diver => Factory.create(:another_user))
      mock_mailer = mock(:mailer, :deliver => true)
      @buddy.stub!(:last_request_emailed_at).and_return(25.hours.ago)
      Notifier.should_receive(:request_confirmation_from_buddy).and_return(mock_mailer)
      @buddy.send_confirmation_request
      @buddy.reload
    end

    it 'should deliver the notification' do
      @buddy.buddy_diver.last_request_emailed_at.should be > 5.minutes.ago
    end

  end


  context 'not senting a confirmation request email' do
    before do
      @buddy = Factory.create(:buddy, :buddy_diver => Factory.create(:another_user))
      @buddy.buddy_diver.stub!(:last_request_emailed_at).and_return(23.hours.ago)
      Notifier.should_not_receive(:request_confirmation_from_buddy)
    end


    it 'should not deliver the notification' do
      @buddy.send_confirmation_request
    end

  end

  context 'role not set' do
    before { @buddy = Buddy.new :role => '' }

    it 'should have a role_s' do
      @buddy.role_s.should eql('Buddy')
    end

  end

  context "Actionable" do
    before { @buddy = Buddy.new }

    it "should be actionable" do
      @buddy.stub!(:unconfirmed).and_return(false)
    end

    it "should not be actionable" do
      @buddy.stub!(:unconfirmed).and_return(true)
    end
  end

  context "with a diver" do
    before do
      @user = Factory.create(:user, :name => "A Diver's Name")
      @dive = Factory.create(:dive, :diver => @user)
      @another_user = Factory.create(:another_user, :name => 'Another User')
      @buddy = Factory.create(:buddy, :dive => @dive, :buddy_diver => @another_user)
    end

    it 'should have a buddy_diver_name' do
      @buddy.buddy_diver_name.should eql('Another User')
    end

    context "adding himself as a buddy" do
      before do
        @invalid_buddy = @dive.buddies.new :buddy_diver_name => @user.email
      end

      it "should not be valid" do
        @invalid_buddy.should have(1).error_on(:buddy_diver_name)
      end
    end
  end

  context "creating with a buddy_diver_name that is an email" do
    before do
      @user = Factory.create(:user, :name => "A Diver's Name")
      @dive = Factory.create(:dive, :diver => @user)
      @another_user = Factory(:another_user, :name => 'Another User')
      @buddy = Factory.create(:buddy, :dive => @dive, :buddy_diver => @another_user)
    end

    it 'should add the buddy_diver' do
      @buddy.buddy_diver.should be_an_instance_of(User)
    end

    it 'should have a buddy_diver_name' do
      @buddy.buddy_diver_name.should eql('Another User')
    end
  end


  context "creating with a buddy_diver_name that is an email" do
    before do
      @user = Factory.create(:user, :name => "A Diver's Name")
      @dive = Factory.create(:dive, :diver => @user)
      @buddy = Factory.create(:buddy, :dive => @dive, :buddy_diver_name => 'another_user@example.com')
    end

    it 'should add the buddy_diver' do
      @buddy.buddy_diver.should be_an_instance_of(User)
    end

    it 'should have a buddy_diver_name' do
      @buddy.buddy_diver_name.should eql('another_user@example.com')
    end
  end

  context "state machine" do
    before do
      @dive = Factory.create(:dive, :diver => Factory(:user))
      @other_diver = Factory.create(:another_user)
      @buddy = Factory.create(:buddy, :dive => @dive, :buddy_diver => @another_diver)
    end

    it "should assign the GUID" do
      @buddy.guid.should be_present
    end

    it "should have an initial state of 'unconfirmed'" do
      @buddy.should be_unconfirmed
    end

    context "requesting confirmation from a new buddy" do
      before do
        @buddy.buddy_diver_name = 'a-new-person@example.com'
        @buddy.request_confirmation!
      end

      it 'should be awaiting confirmation' do
        @buddy.should be_awaiting_confirmation
      end

      it 'should not assign the diver' do
        @buddy.buddy_diver.should_not nil
      end
    end

    context "requesting confirmation from a new buddy who exists in our users table" do
      before do
        @buddy.buddy_diver_name = @other_diver.email
        @buddy.request_confirmation!
      end

      it 'should be awaiting confirmation' do
        @buddy.should be_awaiting_confirmation
      end

      it 'should assign the diver' do
        @buddy.buddy_diver.should eql(@other_diver)
      end
    end


    context "requesting confirmation from a new buddy without a diver" do
      before do
        @buddy.buddy_diver = nil
        @buddy.request_confirmation!
      end

      it 'should not be awaiting confirmation' do
        @buddy.should_not be_awaiting_confirmation
      end

      it 'should still be status: unconfirmed' do
        @buddy.should be_unconfirmed
      end

      it 'should not assign the diver' do
        @buddy.buddy_diver.should be_nil
      end
    end

    context "requesting confirmation from an existing buddy" do
      before do
        @buddy.buddy_diver = @other_diver
        @buddy.request_confirmation!
      end

      it 'should be awaiting confirmation' do
        @buddy.should be_awaiting_confirmation
      end
    end
  end
end
