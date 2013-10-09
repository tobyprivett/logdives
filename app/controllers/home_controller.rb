class HomeController < ApplicationController
  def show
    if user_signed_in?
      redirect_to '/dives'
    else
      redirect_to '/latest'
    end

  end
end
