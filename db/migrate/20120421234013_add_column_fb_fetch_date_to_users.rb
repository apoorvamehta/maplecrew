class AddColumnFbFetchDateToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :fb_fetch_date, :datetime
  	add_index :users, :fb_fetch_date
  end
end
