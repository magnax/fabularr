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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131022115533) do

  create_table "char_names", force: true do |t|
    t.integer  "character_id"
    t.integer  "named_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "char_names", ["character_id", "named_id"], name: "index_char_names_on_character_id_and_named_id", unique: true, using: :btree
  add_index "char_names", ["character_id"], name: "index_char_names_on_character_id", using: :btree
  add_index "char_names", ["named_id"], name: "index_char_names_on_named_id", using: :btree

  create_table "characters", force: true do |t|
    t.string   "name"
    t.string   "gender"
    t.integer  "location_id"
    t.integer  "spawn_location_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: true do |t|
    t.integer  "locationtype_id"
    t.integer  "locationclass_id"
    t.string   "name"
    t.integer  "parent_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
