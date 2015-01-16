class CreateCommitments < ActiveRecord::Migration
  def change
  	create_table :commitments do |t|
  		t.belongs_to :user
  		t.datetime :scheduled_for
  		t.datetime :deleted_at
  		t.boolean :verified
  		t.datetime :verified_at

  		t.timestamps
  	end
  end
end
