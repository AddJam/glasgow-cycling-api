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

ActiveRecord::Schema.define(version: 20140217134722) do

  create_table "events", force: true do |t|
    t.integer  "type"
    t.integer  "attraction_id"
    t.string   "name"
    t.text     "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.text     "road_closure_details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "route_reviews", force: true do |t|
    t.integer  "route_id"
    t.text     "comment"
    t.integer  "user_id"
    t.integer  "safety_rating"
    t.integer  "difficulty_rating"
    t.integer  "environment_rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routepoints", force: true do |t|
    t.integer  "route_id"
    t.float    "lat"
    t.float    "long"
    t.integer  "preceding_route_point_id"
    t.integer  "next_route_point_id"
    t.float    "altitude"
    t.float    "incline"
    t.integer  "time_from_preceding"
    t.boolean  "on_road"
    t.string   "street_name"
    t.string   "street_postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", force: true do |t|
    t.integer  "created_by"
    t.string   "name"
    t.float    "start_lat"
    t.float    "start_long"
    t.float    "end_lat"
    t.float    "end_long"
    t.integer  "calculated_total_time"
    t.float    "total_distance"
    t.datetime "last_used"
    t.integer  "mode"
    t.integer  "safety"
    t.integer  "difficulty"
    t.integer  "start_picture_id"
    t.integer  "end_picture_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weather_periods", force: true do |t|
    t.integer  "weather_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "precipitation_type"
    t.integer  "precipitation_level"
    t.integer  "wind_speed"
    t.integer  "wind_direction"
    t.integer  "pollen_count"
    t.integer  "uv_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weathers", force: true do |t|
    t.datetime "date"
    t.datetime "sunset"
    t.datetime "sunrise"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
