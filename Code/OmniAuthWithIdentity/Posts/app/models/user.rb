class User < ActiveRecord::Base
  has_many :posts

  def self.create_with_omniauth(auth)
    # NOTE: THE FOLLOWING CALL DOES NOT HANDLE ADDING THE USER ATTRIBUTES (ACCESS TOKENS, EMAIL ADDRESSES ETC)FROM FACEBOOK TO THE USERS MODEL
    create! do |user|
      # Following assignments happen before the record is saved to the database when a block is passed to create!
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]

      # You could save additional information to the database here (E.g.: facebook access token, email address, etc...)
    end
  end
end
