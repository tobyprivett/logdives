class PublicDivesController < ApplicationController
  respond_to :html, :js
  def show
    @dive = Dive.lightly.find(params[:id])
    redirect_to edit_dive_path(@dive)  and return if user_signed_in? && @dive.diver == current_user
    respond_with(@dive)
  end

  def index
    @dives = Dive.last_updated.lightly.page(params[:page]).per(50)
  end
end
