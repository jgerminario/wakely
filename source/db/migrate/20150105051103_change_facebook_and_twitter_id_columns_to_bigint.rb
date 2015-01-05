class ChangeFacebookAndTwitterIdColumnsToBigint < ActiveRecord::Migration
  def change
  	change_column :twitter_events, :twitter_id, :integer, limit: 8
  	change_column :facebook_events, :facebook_id, :integer, limit: 8
  end
end
