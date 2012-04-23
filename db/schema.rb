# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120422044430) do

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "facebook_friends", :force => true do |t|
    t.string   "facebook_id"
    t.string   "name"
    t.string   "gender"
    t.string   "location"
    t.string   "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_friends", ["facebook_id"], :name => "index_facebook_friends_on_facebook_id"
  add_index "facebook_friends", ["gender"], :name => "index_facebook_friends_on_gender"
  add_index "facebook_friends", ["location"], :name => "index_facebook_friends_on_location"
  add_index "facebook_friends", ["name"], :name => "index_facebook_friends_on_name"

  create_table "facebook_friends_users", :id => false, :force => true do |t|
    t.integer "facebook_friend_id"
    t.integer "user_id"
  end

  add_index "facebook_friends_users", ["facebook_friend_id", "user_id"], :name => "index_facebook_friends_users_on_facebook_friend_id_and_user_id"

  create_table "users", :force => true do |t|
    t.string   "facebook_id"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "location"
    t.string   "access_token"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "fb_fetch_date"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["fb_fetch_date"], :name => "index_users_on_fb_fetch_date"
  add_index "users", ["location"], :name => "index_users_on_location"
  add_index "users", ["name"], :name => "index_users_on_name"

end
