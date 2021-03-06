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

ActiveRecord::Schema.define(version: 20170414093639) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aircond_groups", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aircond_states", force: :cascade do |t|
    t.integer  "status"
    t.integer  "mode"
    t.integer  "fan_speed"
    t.integer  "temperature"
    t.string   "ir_signal"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "airconds", force: :cascade do |t|
    t.integer  "device_id"
    t.integer  "aircond_state_id"
    t.integer  "status",           default: 2
    t.integer  "mode"
    t.integer  "fan_speed"
    t.integer  "temperature"
    t.time     "timer_on"
    t.string   "alias"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "aircond_group_id"
    t.time     "timer_off"
    t.index ["aircond_state_id"], name: "index_airconds_on_aircond_state_id", using: :btree
    t.index ["device_id"], name: "index_airconds_on_device_id", using: :btree
  end

  create_table "authentications", force: :cascade do |t|
    t.string   "uid"
    t.string   "token"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_authentications_on_user_id", using: :btree
  end

  create_table "devices", force: :cascade do |t|
    t.string   "url"
    t.string   "access_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "infrared_signals", force: :cascade do |t|
    t.string   "command"
    t.string   "ir_signal_in_conf"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "phone_apps", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "status",          default: 0
    t.string   "user_name"
    t.string   "password"
    t.string   "password_digest"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "email",                                      null: false
    t.string   "encrypted_password", limit: 128
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,             null: false
    t.integer  "role",                           default: 1
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["remember_token"], name: "index_users_on_remember_token", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.json     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "authentications", "users"
end
