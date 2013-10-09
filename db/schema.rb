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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110822161456) do

  create_table "buddies", :force => true do |t|
    t.integer  "buddy_diver_id"
    t.integer  "dive_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.string   "guid"
    t.integer  "reciprocal_dive_id"
  end

  add_index "buddies", ["buddy_diver_id"], :name => "index_buddies_on_buddy_diver_id"
  add_index "buddies", ["dive_id"], :name => "index_buddies_on_dive_id"
  add_index "buddies", ["guid"], :name => "index_buddies_on_guid"
  add_index "buddies", ["reciprocal_dive_id"], :name => "index_buddies_on_reciprocal_dive_id"
  add_index "buddies", ["state"], :name => "index_buddies_on_state"

  create_table "conditions", :force => true do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dive_sites", :force => true do |t|
    t.string   "site"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "added_by_id"
    t.text     "images_hash"
    t.text     "weblinks_hash"
    t.string   "source"
    t.string   "latlong_builder"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "name"
  end

  add_index "dive_sites", ["added_by_id"], :name => "index_dive_sites_on_added_by_id"
  add_index "dive_sites", ["name"], :name => "index_dive_sites_on_name"

  create_table "dives", :force => true do |t|
    t.integer  "diver_id"
    t.integer  "user_upload_id"
    t.integer  "total_dive_time"
    t.date     "dive_date"
    t.float    "max_depth_amount"
    t.float    "average_depth_amount"
    t.integer  "sample_interval"
    t.string   "title"
    t.string   "location"
    t.string   "dive_site"
    t.string   "weather"
    t.string   "visibility"
    t.float    "air_temperature"
    t.float    "water_temperature_at_depth"
    t.float    "water_temperature_on_surface"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "samples"
    t.string   "cached_slug"
    t.integer  "dive_no"
    t.string   "depth_unit",                   :default => "metric"
    t.float    "weight_amount"
    t.string   "weight_unit",                  :default => "metric"
    t.string   "temperature_unit",             :default => "metric"
    t.boolean  "profile_visible",              :default => true
    t.boolean  "photos_visible",               :default => true
    t.boolean  "tanks_visible",                :default => true
    t.boolean  "equipment_visible",            :default => true
    t.boolean  "conditions_visible",           :default => true
    t.boolean  "buddy_visible",                :default => true
    t.integer  "rating",                       :default => 0
    t.boolean  "notes_visible",                :default => true
    t.time     "time_in"
    t.time     "time_out"
    t.string   "template",                     :default => "rec"
    t.integer  "safety_stop"
    t.integer  "bottom_time"
    t.string   "type_of"
    t.integer  "tank_type_id"
    t.integer  "photos_count",                 :default => 0
    t.string   "description"
  end

  add_index "dives", ["cached_slug"], :name => "index_dives_on_cached_slug", :unique => true
  add_index "dives", ["diver_id"], :name => "index_dives_on_diver_id"
  add_index "dives", ["template"], :name => "index_dives_on_template"

  create_table "dives_conditions", :id => false, :force => true do |t|
    t.integer "dive_id"
    t.integer "condition_id"
  end

  create_table "dives_exposure_suits", :id => false, :force => true do |t|
    t.integer "dive_id"
    t.integer "exposure_suit_id"
  end

  create_table "exposure_suits", :force => true do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "dive_id"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "tanks", :force => true do |t|
    t.integer  "dive_id"
    t.integer  "start_pressure"
    t.integer  "end_pressure"
    t.string   "pressure_unit",  :default => "metric"
    t.float    "he",             :default => 0.0
    t.float    "o2",             :default => 21.0
    t.float    "n2",             :default => 79.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mix_type",       :default => "Air"
    t.string   "volume"
    t.string   "volume_unit"
  end

  add_index "tanks", ["dive_id"], :name => "index_tanks_on_dive_id"

  create_table "user_uploads", :force => true do |t|
    t.integer  "user_id"
    t.string   "file"
    t.datetime "processed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  add_index "user_uploads", ["cached_slug"], :name => "index_user_uploads_on_cached_slug", :unique => true
  add_index "user_uploads", ["user_id"], :name => "index_user_uploads_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                  :default => "",       :null => false
    t.string   "encrypted_password",      :limit => 128, :default => "",       :null => false
    t.string   "password_salt",                          :default => "",       :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "log_start_no",                           :default => 1
    t.string   "units",                                  :default => "metric"
    t.string   "name"
    t.string   "avatar"
    t.string   "cached_slug"
    t.datetime "last_request_emailed_at"
    t.text     "bio"
    t.string   "guid"
    t.string   "rpx_identifier"
  end

  add_index "users", ["cached_slug"], :name => "index_users_on_cached_slug"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "waypoints", :force => true do |t|
    t.integer  "dive_id"
    t.integer  "time"
    t.string   "name"
    t.float    "depth_amount"
    t.string   "depth_unit",   :default => "metric"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration",     :default => 1
  end

  add_index "waypoints", ["dive_id"], :name => "index_waypoints_on_dive_id"

end
