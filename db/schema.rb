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

ActiveRecord::Schema.define(version: 20170413085300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connections", force: :cascade do |t|
    t.datetime "disconnected_at"
    t.float    "download_data",   default: 0.0
    t.float    "upload_data",     default: 0.0
    t.datetime "connected_at"
    t.float    "total_bill",      default: 0.0
    t.integer  "wifi_id"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["user_id"], name: "index_connections_on_user_id", using: :btree
    t.index ["wifi_id"], name: "index_connections_on_wifi_id", using: :btree
  end

  create_table "lenders", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "mobile_number"
    t.string   "password_digest"
    t.string   "token"
    t.string   "password_reset_token"
    t.string   "email_verify_token"
    t.string   "mobile_verify_token"
    t.boolean  "email_verified",         default: false
    t.boolean  "mobile_number_verified", default: false
    t.boolean  "blocked",                default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "rate",          default: 1
    t.integer  "connection_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["connection_id"], name: "index_ratings_on_connection_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "mobile_number"
    t.string   "password_digest"
    t.string   "token"
    t.string   "password_reset_token"
    t.string   "email_verify_token"
    t.boolean  "email_verified",          default: false
    t.boolean  "blocked",                 default: false
    t.boolean  "successfully_terminated", default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "wifis", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.string   "name"
    t.string   "password"
    t.string   "ssid"
    t.string   "security_type"
    t.float    "price",         default: 0.0
    t.integer  "avg_speed"
    t.boolean  "blocked",       default: false
    t.integer  "lender_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["lender_id"], name: "index_wifis_on_lender_id", using: :btree
  end

end
