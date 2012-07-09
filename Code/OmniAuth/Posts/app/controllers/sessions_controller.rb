class SessionsController < ApplicationController
  def new

  end

  def create
    #raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id

    ru = session[:saved_url] || root_url
    session[:saved_url] = nil
    redirect_to ru, :notice => "Logged in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => 'Logged Out!'
  end
end
