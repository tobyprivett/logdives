class BuddyRequestsController < ApplicationController
  before_filter :load_buddy_and_dive, :only => [:show, :gateway]
  before_filter :check_buddy_awaiting_confirmation, :only => [:show, :gateway]
  before_filter :sign_in_user, :only => [:gateway]

  def index
    @buddy = current_user.new_buddy_requests.first
    if @buddy
      redirect_to buddy_request_path(@buddy)
    else
      redirect_to buddy_confirmations_path
    end
  end

  def show

  end

  def gateway
    render 'show'
  end

  protected

  def load_buddy_and_dive
    @buddy = Buddy.find(params[:id])
    @dive = @buddy.dive
  end

  def check_buddy_awaiting_confirmation
    redirect_to buddy_confirmations_path unless @buddy.awaiting_confirmation?
  end

  def sign_in_user
    sign_in @buddy.buddy_diver
  end
end
