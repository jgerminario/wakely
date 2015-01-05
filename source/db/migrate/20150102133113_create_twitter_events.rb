class CreateTwitterEvents < ActiveRecord::Migration
  def change
  	create_table :twitter_events do |t|
  		t.belongs_to :commitment
  		t.string :tweet
  		t.integer :twitter_id
  		t.datetime :posted_on_twitter_at
  		t.datetime :deleted_from_twitter_at

  		t.timestamps
  	end
  end
end
