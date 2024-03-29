# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2013_10_22_115533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "char_names", id: :serial, force: :cascade do |t|
    t.integer "character_id"
    t.integer "named_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["character_id", "named_id"], name: "index_char_names_on_character_id_and_named_id", unique: true
    t.index ["character_id"], name: "index_char_names_on_character_id"
    t.index ["named_id"], name: "index_char_names_on_named_id"
  end

  create_table "characters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "gender"
    t.integer "location_id"
    t.integer "spawn_location_id"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.integer "locationtype_id"
    t.integer "locationclass_id"
    t.string "name"
    t.integer "parent_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "remember_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

end
