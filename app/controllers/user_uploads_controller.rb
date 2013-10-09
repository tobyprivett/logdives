class UserUploadsController < ApplicationController
  def new
    @user_upload = UserUpload.new
  end

  def create
    @user_upload = UserUpload.new(params[:user_upload])
    @user_upload.user = current_user
    if @user_upload.save
      redirect_to user_upload_path(@user_upload), :notice => "File successfully uploaded"
    else
      render :action => 'new'
    end
  end

  def show
    @user_upload = current_user.user_uploads.find(params[:id])
  end

end
