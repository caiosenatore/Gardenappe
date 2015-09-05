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

ActiveRecord::Schema.define(version: 20150826022326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 100
    t.boolean  "activated",              default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "groups", ["activated"], name: "index_groups_on_activated", using: :btree
  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree

  create_table "groups_transactions", id: false, force: :cascade do |t|
    t.integer "group_id",       null: false
    t.integer "transaction_id", null: false
  end

  add_index "groups_transactions", ["group_id"], name: "index_groups_transactions_on_group_id", using: :btree
  add_index "groups_transactions", ["transaction_id"], name: "index_groups_transactions_on_transaction_id", using: :btree

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "group_id", null: false
  end

  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id", using: :btree
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.string   "name",       limit: 100
    t.boolean  "can_read",               default: true
    t.boolean  "can_edit",               default: true
    t.boolean  "can_create",             default: true
    t.boolean  "can_delete",             default: true
    t.boolean  "activated",              default: true
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "transactions", ["activated"], name: "index_transactions_on_activated", using: :btree
  add_index "transactions", ["name"], name: "index_transactions_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",               limit: 100,                 null: false
    t.string   "password_digest"
    t.string   "fullname",            limit: 130,                 null: false
    t.string   "facebook",            limit: 200
    t.string   "email_token",         limit: 200
    t.boolean  "is_an_administrator",             default: false
    t.boolean  "activated",                       default: true
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["activated"], name: "index_users_on_activated", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
