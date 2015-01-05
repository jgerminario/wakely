class CreateAuthorizations < ActiveRecord::Migration
  def change
  	create_table :authorizations do |t|
  		t.belongs_to :user
  		t.string :platform
  		t.string :username
  		t.string :access_code
  		t.string :refresh_token

  		t.timestamps
  	end
  end
end
