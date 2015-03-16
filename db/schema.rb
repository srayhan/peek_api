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

ActiveRecord::Schema.define(version: 20150314185045) do

  create_table "assignments", force: true do |t|
    t.integer  "timeslot_id"
    t.integer  "boat_id"
    t.string   "status",       default: "AVAILABLE"
    t.integer  "lock_version", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["boat_id"], name: "index_assignments_on_boat_id"
  add_index "assignments", ["status"], name: "index_assignments_on_status"
  add_index "assignments", ["timeslot_id"], name: "index_assignments_on_timeslot_id"

  create_table "boats", force: true do |t|
    t.string   "name"
    t.integer  "capacity",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boats", ["capacity"], name: "index_boats_on_capacity"
  add_index "boats", ["name"], name: "index_boats_on_name"

  create_table "bookings", force: true do |t|
    t.integer  "timeslot_id"
    t.integer  "boat_id"
    t.integer  "size",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bookings", ["boat_id"], name: "index_bookings_on_boat_id"
  add_index "bookings", ["timeslot_id"], name: "index_bookings_on_timeslot_id"

  create_table "timeslots", force: true do |t|
    t.integer  "start_time",   limit: 8, default: 0, null: false
    t.integer  "duration",               default: 0
    t.integer  "lock_version",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "timeslots", ["start_time"], name: "index_timeslots_on_start_time", unique: true

end
