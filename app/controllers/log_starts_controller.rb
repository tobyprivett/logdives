class LogStartsController < ApplicationController
   def update
    @user = User.find(current_user)
    @user.log_start_no = params[:user][:log_start_no]

    if @user.invalid?
      redirect_to preferences_path, :notice => 'Could not complete request'
    else
      @user.save
      @user.set_log_start_no!
      redirect_to preferences_path, :notice => 'The dive numbers have been reset'
     end
  end
end
