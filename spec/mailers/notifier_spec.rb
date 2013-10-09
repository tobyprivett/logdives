require "spec_helper"

describe Notifier do
  context "request_confirmation_from_buddy" do
    before do
      @dive = Factory.create(:dive)
    end

    context 'buddy has never logged in' do
      before do
        @buddy_diver = Factory.create(:another_user, :last_sign_in_at => nil, :reset_password_token => 'abcde')
        @buddy = Factory.create(:buddy, :dive => @dive, :buddy_diver => @buddy_diver)
        @email = Notifier.request_confirmation_from_buddy(@buddy)
      end

      it "should set deliver to" do
        @email.should deliver_to(@buddy_diver.email)
      end

      it "should set subject" do
        @email.subject.should =~ /Confirmation request/
      end

      it "should have body text content" do
        @email.body.should =~ /http:\/\/127.0.0.1:3000\/br\/#{@buddy.to_param}/
      end

      it "should have a link to set the password" do
         @email.body.should =~ /reset_password_token/
      end
    end

    context 'buddy has previously logged in' do
      before do
        @buddy_diver = Factory.create(:another_user, :last_sign_in_at => 1.day.ago)
        @buddy = Factory.create(:buddy, :dive => @dive, :buddy_diver => @buddy_diver)
        @email = Notifier.request_confirmation_from_buddy(@buddy)
      end


      it "should not have a link to set the password" do
        @email.body.should_not match /reset_password_token/
      end

    end
  end
end
