class AddLocationVerificationAssociationAndVerifiedColumn < ActiveRecord::Migration
  def change
  	add_column :location_checkins, :validity, :boolean
  	add_column :location_checkins, :location_verification_id, :integer
  end
end
