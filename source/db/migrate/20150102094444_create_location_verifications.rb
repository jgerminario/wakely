class CreateLocationVerifications < ActiveRecord::Migration
  def change
  	create_table :location_verifications do |t|
  		t.decimal :latitude
  		t.decimal :longitude
  		t.integer :distance_in_meters

  		t.timestamps
  	end
  end
end
