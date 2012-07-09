class SessionsController < ApplicationController
  def new
  end

  def create
    #raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]

    # NOTE: THE FOLLOWING CALL DOES NOT HANDLE ADDING THE USER ATTRIBUTES (ACCESS TOKENS, EMAIL ADDRESSES ETC)FROM FACEBOOK TO THE USERS MODEL
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
