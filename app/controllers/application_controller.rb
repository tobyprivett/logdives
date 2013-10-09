class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user

  def set_user
    if user_signed_in?
      if params[:units]
        current_user.update_attribute :units, params[:units].to_sym
      end
      @u = current_user
    else
      @u =  User.new
      if params[:units].present?
        @u.units = params[:units]
      elsif session[:units].present?
        @u.units = session[:units]
      end
      session[:units] = @u.units
    end
  end

end
