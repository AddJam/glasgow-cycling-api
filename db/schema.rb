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

ActiveRecord::Schema.define(version: 20141204150200) do

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
    t.boolean  "is_city",          default: false
  end

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",         null: false
    t.string   "uid",          null: false
    t.string   "secret",       null: false
    t.text     "redirect_uri", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

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
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rating"
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
    t.string   "source"
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
    t.integer  "gender"
    t.string   "profile_pic_file_name"
    t.string   "profile_pic_content_type"
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
    t.integer  "year_of_birth"
    t.string   "username"
  end

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
    t.datetime "date"
    t.datetime "sunset"
    t.datetime "sunrise"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
