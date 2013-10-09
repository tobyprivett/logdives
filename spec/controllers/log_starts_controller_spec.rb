require 'spec_helper'

describe LogStartsController do
  login_user
  render_views

  context "updating" do
    before do
      @another_user = Factory.create(:another_user)
      User.stub!(:find).and_return(@another_user)
    end

    it "succeeds" do
      @another_user.stub!(:save).and_return(true)
      @another_user.stub!(:set_log_start_no!).and_return(@user)
      put :update, :user => { :log_starts_at => 350 }
    end

    it "updates and fails" do
      @another_user.stub!(:save).and_return(false)
      put :update, :user => { :log_starts_at => 'bad_data' }
      flash[:notice].should =~ /Could not complete request/
      response.should redirect_to(preferences_path)

    end
  end
end
