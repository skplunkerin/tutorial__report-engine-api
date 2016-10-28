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

ActiveRecord::Schema.define(version: 20161028161701) do

  create_table "engines", force: :cascade do |t|
    t.string   "name"
    t.string   "status"
    t.string   "apikey"
    t.datetime "deleted_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "properties", force: :cascade do |t|
    t.integer  "engine_id"
    t.integer  "user_id"
    t.string   "name"
    t.string   "status"
    t.text     "notes"
    t.string   "apikey"
    t.datetime "deleted_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "properties_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "property_id"
  end

  add_index "properties_users", ["property_id"], name: "index_properties_users_on_property_id"
  add_index "properties_users", ["user_id"], name: "index_properties_users_on_user_id"

  create_table "reports", force: :cascade do |t|
    t.integer  "property_id"
    t.string   "name"
    t.text     "summary"
    t.string   "status"
    t.datetime "publish_date"
    t.string   "version"
    t.text     "notes"
    t.datetime "initial_view_date"
    t.integer  "view_count"
    t.string   "apikey"
    t.datetime "deleted_date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id"

  create_table "sections", force: :cascade do |t|
    t.integer  "report_id"
    t.integer  "order"
    t.string   "name"
    t.string   "status"
    t.text     "content"
    t.string   "apikey"
    t.datetime "deleted_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer  "engine_id"
    t.string   "name"
    t.string   "email"
    t.string   "status"
    t.text     "notes"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "apikey"
    t.datetime "deleted_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
