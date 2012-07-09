require 'json'
require 'openssl'
require 'net/https'
require 'uri'


class SessionsController < ApplicationController
  def new
    session[:fb_state] = SecureRandom.hex
    setup_fb_connect_url()
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to_saved_url("Logged in!")
    else
      setup_fb_connect_url()
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    destroy_auth_keys()
    redirect_to root_url, :notice => "Logged out!"
  end

  def fb_auth
    if(!params[:state] || params[:state] != session[:fb_state])
      destroy_auth_keys
      redirect_to root_url, :notice => 'Invalid Request'
    elsif params[:error]
      destroy_auth_keys
      redirect_to root_url, :notice => "#{params[:error]}: #{params[:error_description]}"
    else
      user_access_token_response = query_facebook_graph "https://graph.facebook.com/oauth/access_token?client_id=#{FACEBOOK_CONFIG[:app_id]}&redirect_uri=#{CGI::escape(fb_auth_url)}&client_secret=#{FACEBOOK_CONFIG[:app_secret]}&code=#{params[:code]}"
      access_token_with_expiration = Hash[*user_access_token_response.split('&').map{|p| p.split('=')}.flatten] if user_access_token_response
      user_info = query_facebook_graph("https://graph.facebook.com/me?access_token=#{access_token_with_expiration['access_token']}") if access_token_with_expiration
      user = User.find_or_create_by_facebook_info(user_info, access_token_with_expiration)
      if(user)
        session[:user_id] = user.id
        redirect_to_saved_url("Logged in!")
      else
        destroy_auth_keys
        redirect_to_saved_url("Something went wrong. Please try again!")
      end
    end
  end

  private

  def destroy_auth_keys
    session[:user_id] = nil
    session[:fb_state] = nil
  end

  def setup_fb_connect_url
    facebook_auth_redirect_url = CGI::escape(fb_auth_url)
    @fb_connect_url = "https://www.facebook.com/dialog/oauth?client_id=#{FACEBOOK_CONFIG[:app_id]}&redirect_uri=#{facebook_auth_redirect_url}&scope=#{FACEBOOK_CONFIG[:permissions]}&state=#{session[:fb_state]}"
  end

  def query_facebook_graph(url)
    Rails.logger.debug "#{url}"
    uri = URI.parse(url)

    get_path = uri.path;
    if uri.query
      get_path = get_path + "?#{uri.query}"
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    data = nil
    http.start {
      http.request_get(get_path) { |res|
        body = res.body;
        begin
          data = JSON.parse(body)
        rescue JSON::ParserError => ex
          data = body
        end
      }
    }
    data
  end

end
