class UsersController < ApplicationController
  force_ssl

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id

      ru = session[:saved_url] || root_url
      session[:saved_url] = nil
      redirect_to ru, :notice => "Signed up!"
    else
      render "new"
    end
  end
end
