class AddCommitmentIdToLocationVerifications < ActiveRecord::Migration
  def change
  	add_column :location_verifications, :commitment_id, :integer
  end
end
