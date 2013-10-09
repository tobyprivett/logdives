class UsersController < ApplicationController
  def index

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js do
        if params[:term]
          @users = User.all(:conditions => ["name like ? or email like ?", '%' + params[:term] + '%', params[:term] + '%'])
        else
          @users = User.limit(100)
        end
      end
    end
  end

  def update
    @user = current_user

    if @user.update_attributes(params[:user])
      sign_in(current_user, :bypass => true) if params[:user][:password].present?
      redirect_to preferences_path, :notice => "Your account has been updated"
    else
      current_user.reload
      render :template => 'preferences/show'
    end

  end
end
