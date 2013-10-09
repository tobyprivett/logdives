class ProfilesController < ApplicationController
  before_filter :load_user
  before_filter :ensure_viewable, :only => [:show]
  before_filter :ensure_editable, :except => [:show]

  def show
    @dives = @user.dives.includes(:photos, :slug).page(params[:page]).per(50)
  end

  def edit
  end

  def update
    @user.bio = params[:user][:bio]
    @user.avatar = params[:user][:avatar] if params[:user][:avatar].present?

    if @user.save
      redirect_to dives_path
    else
      render :action => 'edit'
    end
  end

  protected

  def load_user
    @user = User.find(params[:id])
  end

  def ensure_viewable
    redirect_to dives_path if @user == current_user
  end

  def ensure_editable
    redirect_to profile_path(@user) unless @user == current_user
  end
end
