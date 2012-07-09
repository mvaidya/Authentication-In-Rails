class User < ActiveRecord::Base
  # Required so that only these fields are mass-assignable through a form.
  # Important since we dont want anybody to change password_hash and password_salt using mass assignment
  attr_accessible :email, :name, :password, :password_confirmation, :facebook_id, :facebook_access_token, :facebook_access_token_expiration, :skip_password_validation

  # Virtual attribute for password field used in the form
  attr_accessor :password, :skip_password_validation
  before_save :encrypt_password

  validates_confirmation_of :password # automatically creates password_confirmation virtual attribute
  validates_presence_of :name, :email
  validates_presence_of :password, :on => :create, :unless => :skip_password_validation
  validates_presence_of :password_confirmation, :on => :create, :unless => :skip_password_validation
  validates_uniqueness_of :email

  has_many :posts

  def self.authenticate(email, password)
    user = find_by_email (email)
    if user && user.password_salt.present? && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      return user
    else
      return nil
    end
  end

  def self.find_or_create_by_facebook_info(facebook_user_info, facebook_access_token_info)
    user = nil
    if(facebook_user_info && facebook_access_token_info)
      user = find_by_email(facebook_user_info['email'])
      if(user)
        user.update_attributes({
            :facebook_id => facebook_user_info['id'],
            :facebook_access_token => facebook_access_token_info['access_token'],
            :facebook_access_token_expiration => facebook_access_token_info['expires']
            })
      else
        user = User.create({
            :skip_password_validation => true,
            :name => facebook_user_info['name'],
            :email => facebook_user_info['email'],
            :facebook_id => facebook_user_info['id'],
            :facebook_access_token => facebook_access_token_info['access_token'],
            :facebook_access_token_expiration => facebook_access_token_info['expires']
        })
        user.save
      end
    end
    return user
  end

  def encrypt_password
    if password.present?
      # NEVER store passwords in plain text. (remember LinkedIn! - http://money.cnn.com/2012/06/06/technology/linkedin-password-hack/index.htm)
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
