class CreateFacebookEvents < ActiveRecord::Migration
  def change
  	create_table :facebook_events do |t|
  		t.belongs_to :commitment
  		t.string :status
  		t.integer :facebook_id
  		t.datetime :posted_on_facebook_at
  		t.datetime :deleted_from_facebook_at

  		t.timestamps
  	end
  end
end
