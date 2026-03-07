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

ActiveRecord::Schema[8.1].define(version: 2026_03_06_162413) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "char_names", id: :serial, force: :cascade do |t|
    t.integer "character_id"
    t.datetime "created_at"
    t.text "description"
    t.string "name"
    t.integer "named_id"
    t.datetime "updated_at"
    t.index ["character_id", "named_id"], name: "index_char_names_on_character_id_and_named_id", unique: true
    t.index ["character_id"], name: "index_char_names_on_character_id"
    t.index ["named_id"], name: "index_char_names_on_named_id"
  end

  create_table "characters", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.string "gender"
    t.integer "location_id"
    t.string "name"
    t.integer "spawn_location_id"
    t.datetime "updated_at"
    t.integer "user_id"
  end

  create_table "events", force: :cascade do |t|
    t.text "body"
    t.integer "character_id"
    t.datetime "created_at", null: false
    t.integer "location_id"
    t.integer "receiver_character_id"
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "itemtype_id"
    t.integer "location_id"
    t.datetime "updated_at", null: false
  end

  create_table "location_resources", force: :cascade do |t|
    t.integer "amount"
    t.datetime "created_at", null: false
    t.integer "location_id"
    t.integer "resource_id"
    t.datetime "updated_at", null: false
  end

  create_table "location_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.datetime "updated_at", null: false
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.integer "location_type_id"
    t.integer "locationclass_id"
    t.string "name"
    t.integer "parent_location_id"
    t.datetime "updated_at"
  end

  create_table "project_types", force: :cascade do |t|
    t.integer "base_speed"
    t.datetime "created_at", null: false
    t.boolean "fixed"
    t.string "key"
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer "amount"
    t.datetime "checked_at"
    t.datetime "created_at", null: false
    t.integer "duration", default: 0
    t.integer "elapsed", default: 0
    t.integer "location_id"
    t.integer "project_type_id"
    t.integer "starting_character_id"
    t.string "unit"
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.binary "channel", null: false
    t.bigint "channel_hash", null: false
    t.datetime "created_at", null: false
    t.binary "payload", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.string "email"
    t.string "password_digest"
    t.string "remember_token"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "workers", force: :cascade do |t|
    t.integer "character_id"
    t.datetime "created_at", null: false
    t.datetime "left_at"
    t.integer "project_id"
    t.datetime "updated_at", null: false
  end
end
