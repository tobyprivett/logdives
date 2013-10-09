class BuddiesController < ApplicationController
  respond_to :html, :js
  before_filter :load_buddy, :only => [:request_confirmation, :destroy]

  def request_confirmation
    (@buddy.request_confirmation! && @buddy.save!)
    respond_with(@buddy)
  end

  def destroy
    @buddy.destroy
    redirect_to edit_dive_path(@buddy.dive), :notice => 'Buddy deleted'
  end

  protected

  def load_buddy
    @buddy = Buddy.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @buddy.dive.diver == current_user
  end
end
