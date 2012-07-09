class User < ActiveRecord::Base
  # Required so that only these fields are mass-assignable through a form.
  # Important since we dont want anybody to change password_hash and password_salt using mass assignment
  attr_accessible :email, :name, :password, :password_confirmation

  # Virtual attribute for password field used in the form
  attr_accessor :password
  before_save :encrypt_password

  validates_confirmation_of :password # automatically creates password_confirmation virtual attribute
  validates_presence_of :name, :email
  validates_presence_of :password, :on => :create
  validates_presence_of :password_confirmation, :on => :create
  validates_uniqueness_of :email

  has_many :posts

  def self.authenticate(email, password)
    user = find_by_email (email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      return user
    else
      return nil
    end
  end

  def encrypt_password
    if password.present?
      # NEVER store passwords in plain text. (remember LinkedIn! - http://money.cnn.com/2012/06/06/technology/linkedin-password-hack/index.htm)
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
