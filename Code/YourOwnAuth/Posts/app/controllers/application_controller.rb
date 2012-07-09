class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :authenticate!

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate!
    if(!current_user)
      session[:saved_url] = request.url
      redirect_to login_path
    end
  end
end
