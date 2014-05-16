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

ActiveRecord::Schema.define(version: 20140516092617) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accidents", force: true do |t|
    t.date     "date"
    t.datetime "time"
    t.integer  "severity"
    t.integer  "police_response"
    t.integer  "casualities"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "long"
  end

  create_table "attractions", force: true do |t|
    t.integer  "type"
    t.float    "lat"
    t.float    "long"
    t.string   "name"
    t.text     "description"
    t.string   "contact_tel"
    t.string   "address1"
    t.string   "address2"
    t.string   "town"
    t.string   "postcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "flaggings", force: true do |t|
    t.integer  "user_id"
    t.integer  "route_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hours", force: true do |t|
    t.integer  "user_id"
    t.datetime "time"
    t.float    "distance"
    t.float    "average_speed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "max_speed"
    t.float    "min_speed"
    t.integer  "num_points",       default: 0
    t.integer  "routes_started",   default: 0
    t.integer  "routes_completed", default: 0
  end

  create_table "pictures", force: true do |t|
    t.string   "url"
    t.string   "label"
    t.float    "lat"
    t.float    "long"
    t.string   "credit_label"
    t.string   "credit_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "route_points", force: true do |t|
    t.integer  "route_id"
    t.float    "lat"
    t.float    "long"
    t.float    "altitude"
    t.boolean  "on_road"
    t.string   "street_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "time"
    t.boolean  "is_important"
    t.float    "kph"
    t.float    "vertical_accuracy"
    t.float    "horizontal_accuracy"
    t.float    "course"
    t.string   "maidenhead"
  end

  add_index "route_points", ["lat", "long"], name: "index_route_points_on_lat_and_long", using: :btree

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

  create_table "routes", force: true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "long"
    t.float    "total_distance"
    t.integer  "mode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "total_time"
    t.integer  "user_id"
    t.string   "start_maidenhead"
    t.string   "end_maidenhead"
    t.string   "start_name"
    t.string   "end_name"
  end

  create_table "user_responses", force: true do |t|
    t.integer  "user_id"
    t.integer  "usage_per_week"
    t.integer  "usage_type"
    t.integer  "usage_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                    default: "", null: false
    t.string   "encrypted_password",       default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "gender"
    t.date     "dob"
    t.string   "authentication_token"
    t.string   "profile_pic_file_name"
    t.string   "profile_pic_content_type"
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weather_periods", force: true do |t|
    t.integer  "weather_id"
    t.datetime "start_time"
    t.string   "precipitation_type"
    t.float    "wind_speed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary"
    t.string   "icon"
    t.float    "precipitation_intensity"
    t.float    "precipitation_probability"
    t.float    "temperature"
    t.float    "dew_point"
    t.float    "humidity"
    t.float    "wind_bearing"
    t.float    "visibility"
    t.float    "cloud_cover"
    t.float    "pressure"
    t.float    "ozone"
  end

  create_table "weathers", force: true do |t|
    t.date     "date"
    t.datetime "sunset"
    t.datetime "sunrise"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
