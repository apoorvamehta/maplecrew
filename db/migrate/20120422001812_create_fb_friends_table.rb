class CreateFbFriendsTable < ActiveRecord::Migration
  def up
  	create_table :facebook_friends do |t|
      t.integer :facebook_id
      t.string :name
      t.string :gender
      t.string :location
      t.string :photo_url
      t.timestamps
    end
    add_index :facebook_friends, :facebook_id
    add_index :facebook_friends, :name
    add_index :facebook_friends, :location
    add_index :facebook_friends, :gender
  end

  def down
  	drop_table :facebook_friends
  end
end
