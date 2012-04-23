class ChangeFacebookIdColumnType < ActiveRecord::Migration
  def up
  	change_column :facebook_friends, :facebook_id, :string
  	change_column :users, :facebook_id, :string
  end
end
