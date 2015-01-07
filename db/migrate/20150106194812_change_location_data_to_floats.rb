class ChangeLocationDataToFloats < ActiveRecord::Migration
  def change
  	change_column :location_verifications, :latitude, :float
  	change_column :location_verifications, :longitude, :float
  	change_column :location_checkins, :latitude, :float
  	change_column :location_checkins, :longitude, :float
  end
end
