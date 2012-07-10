class User < ActiveRecord::Base
  has_secure_password

  # Required so that only these fields are mass-assignable through a form.
  # Important since we dont want anybody to change password_hash and password_salt using mass assignment
  attr_accessible :email, :name, :password, :password_confirmation

  validates_presence_of :name, :email
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email

  has_many :posts
end
