class BuddyConfirmationsController < ApplicationController
  respond_to :html, :js
  before_filter :load_buddy, :except => [:index]
  before_filter :check_buddy_confirmed, :only => [:clone_buddy]

  def show
    @dive = @buddy.dive(:include => [:buddies, :waypoints, :tanks, :photos])
  end

  def update
    @buddy.confirm! && @buddy.save! unless @buddy.confirmed?
    respond_with(@buddy) do |format|
      format.html { redirect_to buddy_confirmation_path(@buddy) }
      format.js
    end
  end

  def destroy
    @buddy.reject! && @buddy.save! if @buddy.awaiting_confirmation?
    respond_with(@buddy) do |format|
      format.html { redirect_to buddy_confirmation_path(@buddy) }
      format.js
    end
  end

  def clone_buddy
    @dive = Dive.reciprocate_for_buddy!(@buddy)
    respond_with(@buddy) do |format|
      format.html { redirect_to buddy_confirmation_path(@buddy) }
      format.js
    end
  end

  def index
    @buddies = current_user.buddy_confirmations.eagerly.page(params[:page]).per(50)
  end

  protected

  def load_buddy
    @buddy = Buddy.find(params[:id])
  end

  def check_buddy_confirmed
    raise ActiveRecord::RecordNotFound unless @buddy.confirmed?
  end
end
