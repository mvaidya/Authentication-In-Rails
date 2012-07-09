Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, APP_CONFIG[:twitter]['consumer_key'], APP_CONFIG[:twitter]['consumer_secret']
  provider :facebook, APP_CONFIG[:facebook]['app_id'], APP_CONFIG[:facebook]['app_secret'], :client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" } }
  provider :identity, on_failed_registration: lambda { |env|
    # lamba is used so that the class IdentitiesController is not cached (imp for dev environment).
    #   That way, changes to the controller will be picked up automatically since lamda is the rack application to handle failures and not IndentitiesController#new directly

    IdentitiesController.action(:new).call(env)
  }

  OmniAuth.config.on_failure  = -> env do
    env[ActionDispatch::Flash::KEY] ||= ActionDispatch::Flash::FlashHash.new
    env[ActionDispatch::Flash::KEY][:error] = "Authentication failed, please try again."
    SessionsController.action(:new).call(env) #call whatever controller/action that displays your signup form
  end
end