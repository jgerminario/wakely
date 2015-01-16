class CreateLocationCheckins < ActiveRecord::Migration
  def change
  	create_table :location_checkins do |t|
  		t.decimal :latitude
  		t.decimal :longitude

  		t.timestamps
  	end
  end
end
