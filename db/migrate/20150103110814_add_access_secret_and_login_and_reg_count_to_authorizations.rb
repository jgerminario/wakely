class AddAccessSecretAndLoginAndRegCountToAuthorizations < ActiveRecord::Migration
  def change
  	add_column :authorizations, :access_secret, :string
  	add_column :authorizations, :login_count, :integer, default: 1
  	add_column :authorizations, :reauthorization_count, :integer, default: 0
  	add_column :authorizations, :platform_user_id, :string
  	rename_column :authorizations, :access_code, :access_token
  end
end
