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

ActiveRecord::Schema.define(version: 20140707012707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "foods", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "foods", ["name"], name: "index_foods_on_name", unique: true, using: :btree

  create_table "foods_vendors", id: false, force: true do |t|
    t.integer  "vendor_id"
    t.integer  "food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "foods_vendors", ["food_id"], name: "index_foods_vendors_on_food_id", using: :btree
  add_index "foods_vendors", ["vendor_id"], name: "index_foods_vendors_on_vendor_id", using: :btree

  create_table "locations", force: true do |t|
    t.decimal  "lon",         precision: 10, scale: 6
    t.decimal  "lat",         precision: 10, scale: 6
    t.text     "description"
    t.text     "address"
    t.integer  "vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["vehicle_id"], name: "index_locations_on_vehicle_id", using: :btree

  create_table "vehicles", force: true do |t|
    t.string   "vehicle_type"
    t.integer  "datasf_object_id"
    t.string   "status"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicles", ["vendor_id"], name: "index_vehicles_on_vendor_id", using: :btree

  create_table "vendors", force: true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vendors", ["name"], name: "index_vendors_on_name", unique: true, using: :btree

end
