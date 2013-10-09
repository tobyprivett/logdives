class DivesController < ApplicationController
  respond_to :html, :js

  def new
    @dive = Dive.init_with_diver(@u)
    @dive.dive_date ||= Date.today
  end

  def create
    @dive = Dive.new params[:dive]
    @dive.diver = current_user

    if @dive.save
      redirect_to edit_dive_path(@dive), :notice => 'The dive has been added to your log.'
    else
      render :action => 'new'
    end
  end

  def edit
    @dive = current_user.dives.eagerly.find(params[:id])
    respond_with(@dive)
  end

  def index
    redirect_to new_dive_path and return unless current_user.dives.present?
    load_dives
  end

  def update
    @dive = current_user.dives.find(params[:id])
    if @dive.update_attributes(params[:dive])
      redirect_to edit_dive_path(@dive), :notice => 'Your log book has been updated.'
    else
      respond_with(@dive)
    end
  end

  def destroy
     @dive = current_user.dives.find(params[:id])
     @dive.destroy if @dive
     redirect_to dives_path, :notice => "The dive has been deleted"
  end

  protected
  def load_dives
    @dives = current_user.dives.lightly.page(params[:page]).per(50)
  end
end
