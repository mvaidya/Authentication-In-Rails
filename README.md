Authentication in Rails
=========================

Basic HTTP Auth in Rails


Your Own Auth
==============

Pros
----
1. Most flexible
2. Easy to setup basic functionality
3. Easy to understand

Cons
----
1. Too much work to make it complete - email confirmation, password field restrictions, email format validations, email correctness validations (confirmations), forgot password retrieval, failed confirmations retry
2. Waste of effort to do it every time
3. Lost focus from your core app

Resources
---------
http://railscasts.com/episodes/250-authentication-from-scratch?autoplay=true



Your Own Auth With Facebook Connect
======================================
https://developers.facebook.com/docs/authentication/
https://developers.facebook.com/docs/authentication/server-side/

Pros and Cons same as before




Auth Logic
===============

Looks Complicated
Auth Logic add-on for Facebook Connect uses Facebooker (too buggy)
The New Auth Logic add on for Facebook Connect uses Facebook JS API (also uses the buggy facebooker2) (not ideal)
Even after using a Plugin, you have to write a lottttttt of code!
Does not generator Controllers and Views. Only generates the underlying logic to handle the complex logic
No Generator Script (in 2009), so takes effort to set-up



OmniAuth
==========

Separate Provider gems - COOL
It is a rack middleware - which makes it very easy to keep it seperate from the main app
Very quick to add FB and TW authentications to the controller. Not easy to merge FB and TW accounts.
No views required since authentication is handled by FB and TW.
You write helpers and session management for getting the current_user and authenticate!

Gotcha for Facebook - SSL Root Cert will not be found
solutions 
  http://stackoverflow.com/questions/3977303/omniauth-facebook-certificate-verify-failed
	https://github.com/intridea/omniauth/issues/260
	What I did: point faraday to a correct CA bundle. Paths depend on your OS. One way to unblock on dev machine is to grab a CA bundle from - http://certifie.com/ca-bundle/. Another option is to monkey patch Faraday and ignore ssl


OmniAuth - With Identity
==========
Almost same as OmniAuth.
need another strategy - omniauth-identity
We also need an additional database table + model to store the omniauth identities. This is different from the users table.
The Identity model class must inherit from OmniAuth::Identity::Models::ActiveRecord
Gotcha: You also need to support "POST" on this path --- '/auth/:provider/callback' => 'sessions#create'
Gotcha: Login uses the email address by default. It can be customized...
Gotcha: Validations on the Identity model wont show up on the register/login UI.
It also provides sign-in/register UI by default

Gotcha: How to handle
1. Registration failures
(In your omniauth initializer, add the on_failed_registration key to identity provider)
provider :identity, on_failed_registration: lambda { |env|
	# lamba is used so that the class IdentitiesController is not cached (imp for dev environment).
	#   That way, changes to the controller will be picked up automatically since lamda is the rack application to handle failures and not IndentitiesController#new directly

	IdentitiesController.action(:new).call(env)
}

2. Login failures? 
(In your omniauth initializer, add this)
OmniAuth.config.on_failure  = -> env do
	env[ActionDispatch::Flash::KEY] ||= ActionDispatch::Flash::FlashHash.new
	env[ActionDispatch::Flash::KEY][:error] = "Authentication failed, please try again."
	SessionsController.action(:new).call(env) #call whatever controller/action that displays your signup form
end
  

Devise
========

devise is an Engine - it gives controllers as well as views and handles everything. Major drawback is you have no idea what is going on internally and have to override a lot of functionality of controller actions and views to customize. Things can get messy there.
One of the most popular and very customizable
has 12 modules to customize
very nice wiki and good documentation
generators are better since all code is right there in the app - nifty-generators has a nifty:authentication generator
views can be overridden - rails g devise:views
Cool: if you are using simple_form, generated views use simple_form as well :)
Add omniauthable to devise - https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview

resources:
