class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and,
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid

  validates_presence_of :name

  has_many :posts

  def self.new_with_session(params, session)
    # Notice that Devise RegistrationsController by default calls "User.new_with_session" before building a resource.
    # This means that, if we need to copy data from session whenever a user is initialized before sign up, we just need to implement new_with_session in our model.
    # Here is an example that copies the facebook email if available:

    # THIS IS SUPER COOL. tHIS KICKS IN WHEN A USER CONNECTS WITH FACEBOOK FOR AN ACCOUNT HE HAS ALREADY CREATED BEFORE! THIS HELPS IN TYING UP FACEBOOK AND EXISTING USER'S ACCOUNT TOGETHER
    # CAN BE EASILY EXTENDED FOR TWITTER AND OTHER AUTH PROVIDERS IF THERE IS A WAY TO TIE UP ACCOUNTS :) aWESOMENESS!!!
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.name = data["name"] if user.name.blank?
      end
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
      )
    end
    user
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:"#{auth.uid}@lvh.me",
                         password:Devise.friendly_token[0,20]
      )
    end
    user
  end
end
