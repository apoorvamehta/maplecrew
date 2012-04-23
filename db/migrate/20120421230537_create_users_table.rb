class CreateUsersTable < ActiveRecord::Migration
  def up
  	create_table :users do |t|
      t.integer :facebook_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :location
      t.string :access_token
      t.string :email
      t.timestamps
    end
    add_index :users, :name
    add_index :users, :email
    add_index :users, :location
  end

  def down
  	drop_table :users
  end
end