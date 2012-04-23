class CreateFbFriendsUsersJoinTable < ActiveRecord::Migration
  def up
  	create_table :facebook_friends_users, :id => false do |t|
      t.references :facebook_friend, :user
    end

    add_index :facebook_friends_users, [:facebook_friend_id, :user_id]
  end

  def down
  	drop_table :facebook_friends_users
  end
end