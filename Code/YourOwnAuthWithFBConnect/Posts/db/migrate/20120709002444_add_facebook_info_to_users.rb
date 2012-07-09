class AddFacebookInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_id, :string
    add_column :users, :facebook_access_token, :string
    add_column :users, :facebook_access_token_expiration, :string
  end
end
