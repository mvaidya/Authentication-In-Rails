#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :twitter, APP_CONFIG[:twitter]['consumer_key'], APP_CONFIG[:twitter]['consumer_secret']
#  provider :facebook, APP_CONFIG[:facebook]['app_id'], APP_CONFIG[:facebook]['app_secret'], :client_options => { :ssl => { :ca_file => "#{Rails.root}/config/ca-bundle.crt" } }
#
#  #OmniAuth.config.on_failure  = -> env do
#  #  env[ActionDispatch::Flash::KEY] ||= ActionDispatch::Flash::FlashHash.new
#  #  env[ActionDispatch::Flash::KEY][:error] = "Authentication failed, please try again."
#  #  SessionsController.action(:new).call(env) #call whatever controller/action that displays your signup form
#  #end
#end