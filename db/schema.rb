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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130529103048) do

  create_table "activities", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "quantity"
    t.string   "display_on"
    t.boolean  "active"
    t.integer  "gym_id"
    t.integer  "venue_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "ancestry"
  end

  add_index "activities", ["ancestry"], :name => "index_activities_on_ancestry"
  add_index "activities", ["gym_id"], :name => "index_activities_on_gym_id"
  add_index "activities", ["venue_type_id"], :name => "index_activities_on_venue_type_id"

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "areas", ["city_id"], :name => "index_areas_on_city_id"

  create_table "card_charges", :force => true do |t|
    t.string   "name"
    t.decimal  "price",      :precision => 8, :scale => 2
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "company_id"
  end

  add_index "card_charges", ["company_id"], :name => "index_card_charges_on_company_id"

  create_table "card_line_items", :force => true do |t|
    t.decimal  "amount",     :precision => 8, :scale => 2
    t.text     "reason"
    t.integer  "card_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "validity"
    t.integer  "order_id"
  end

  add_index "card_line_items", ["card_id"], :name => "index_card_line_items_on_card_id"
  add_index "card_line_items", ["order_id"], :name => "index_card_line_items_on_order_id"

  create_table "card_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "company_id"
  end

  add_index "card_types", ["company_id"], :name => "index_card_types_on_company_id"

  create_table "card_types_gym_groups", :id => false, :force => true do |t|
    t.integer "card_type_id"
    t.integer "gym_group_id"
  end

  add_index "card_types_gym_groups", ["card_type_id", "gym_group_id"], :name => "index_card_types_gym_groups_on_card_type_id_and_gym_group_id"

  create_table "cards", :force => true do |t|
    t.string   "number"
    t.string   "username"
    t.string   "email"
    t.string   "mobile"
    t.decimal  "balance",      :precision => 8, :scale => 2
    t.integer  "user_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "card_type_id"
    t.date     "start_on"
    t.date     "stop_on"
    t.datetime "sold_at"
    t.integer  "company_id"
  end

  add_index "cards", ["card_type_id"], :name => "index_cards_on_card_type_id"
  add_index "cards", ["company_id"], :name => "index_cards_on_company_id"
  add_index "cards", ["email"], :name => "index_cards_on_email"
  add_index "cards", ["mobile"], :name => "index_cards_on_mobile"
  add_index "cards", ["number"], :name => "index_cards_on_number"
  add_index "cards", ["sold_at"], :name => "index_cards_on_sold_at"
  add_index "cards", ["start_on"], :name => "index_cards_on_start_on"
  add_index "cards", ["stop_on"], :name => "index_cards_on_stop_on"
  add_index "cards", ["user_id"], :name => "index_cards_on_user_id"

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "gateway_bills", :force => true do |t|
    t.string   "notification_id"
    t.boolean  "successful"
    t.string   "trade_state"
    t.string   "trade_number"
    t.datetime "notified_at"
    t.string   "customer"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "gateway_bills", ["notification_id"], :name => "index_gateway_bills_on_notification_id"

  create_table "gym_bookmarks", :id => false, :force => true do |t|
    t.integer "gym_id"
    t.integer "user_id"
  end

  add_index "gym_bookmarks", ["gym_id", "user_id"], :name => "index_gym_bookmarks_on_gym_id_and_user_id"

  create_table "gym_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "company_id"
  end

  add_index "gym_groups", ["company_id"], :name => "index_gym_groups_on_company_id"

  create_table "gym_groups_gyms", :id => false, :force => true do |t|
    t.integer "gym_group_id"
    t.integer "gym_id"
  end

  add_index "gym_groups_gyms", ["gym_group_id", "gym_id"], :name => "index_gym_groups_gyms_on_gym_group_id_and_gym_id"

  create_table "gym_images", :force => true do |t|
    t.integer  "gym_id"
    t.integer  "position"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "gym_images", ["gym_id"], :name => "index_gym_images_on_gym_id"

  create_table "gyms", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "open_at"
    t.datetime "close_at"
    t.datetime "confirmed_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "phone"
    t.integer  "company_id"
  end

  add_index "gyms", ["company_id"], :name => "index_gyms_on_company_id"

  create_table "gyms_users", :id => false, :force => true do |t|
    t.integer "gym_id"
    t.integer "user_id"
  end

  add_index "gyms_users", ["gym_id", "user_id"], :name => "index_gyms_users_on_gym_id_and_user_id"

  create_table "line_items", :force => true do |t|
    t.integer  "quantity"
    t.decimal  "price",            :precision => 8, :scale => 2
    t.integer  "order_id"
    t.integer  "purchasable_id"
    t.string   "purchasable_type"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.decimal  "member_price",     :precision => 8, :scale => 2
  end

  add_index "line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "line_items", ["purchasable_id", "purchasable_type"], :name => "index_line_items_on_purchasable_id_and_purchasable_type"

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.string   "zip_code"
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.integer  "area_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
  end

  add_index "locations", ["area_id"], :name => "index_locations_on_area_id"
  add_index "locations", ["locatable_id", "locatable_type"], :name => "index_locations_on_locatable_id_and_locatable_type"

  create_table "orders", :force => true do |t|
    t.string   "number"
    t.decimal  "total",                :precision => 8, :scale => 2
    t.string   "state"
    t.decimal  "payment_total",        :precision => 8, :scale => 2
    t.string   "payment_state"
    t.string   "type"
    t.integer  "user_id"
    t.string   "mobile"
    t.string   "verification_code"
    t.text     "special_instructions"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.integer  "gym_id"
    t.datetime "checked_in_at"
    t.string   "username"
    t.integer  "card_id"
    t.datetime "expired_at"
    t.decimal  "member_total",         :precision => 8, :scale => 2
    t.integer  "payment_method_id"
  end

  add_index "orders", ["card_id"], :name => "index_orders_on_card_id"
  add_index "orders", ["checked_in_at"], :name => "index_orders_on_checked_in_at"
  add_index "orders", ["expired_at"], :name => "index_orders_on_expired_at"
  add_index "orders", ["gym_id"], :name => "index_orders_on_gym_id"
  add_index "orders", ["number"], :name => "index_orders_on_number"
  add_index "orders", ["payment_method_id"], :name => "index_orders_on_payment_method_id"
  add_index "orders", ["user_id"], :name => "index_orders_on_user_id"

  create_table "payment_methods", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "display_on"
    t.boolean  "active"
    t.datetime "deleted_at"
    t.text     "settings"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id"
    t.decimal  "amount",            :precision => 8, :scale => 2
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "payment_method_id"
    t.string   "state"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "payments", ["order_id"], :name => "index_payments_on_order_id"
  add_index "payments", ["payment_method_id"], :name => "index_payments_on_payment_method_id"
  add_index "payments", ["source_id", "source_type"], :name => "index_payments_on_source_id_and_source_type"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "deleted_at"
    t.integer  "count_on_hand"
    t.string   "sku"
    t.decimal  "price",         :precision => 8, :scale => 2
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "gym_id"
  end

  add_index "products", ["gym_id"], :name => "index_products_on_gym_id"

  create_table "real_venues", :force => true do |t|
    t.integer  "count_on_hand"
    t.integer  "max_people"
    t.integer  "venue_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "real_venues", ["venue_id"], :name => "index_real_venues_on_venue_id"

  create_table "recurrence_rules", :force => true do |t|
    t.string   "type"
    t.integer  "date_recurrent_id"
    t.string   "date_recurrent_type"
    t.integer  "time_recurrent_id"
    t.string   "time_recurrent_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.text     "settings"
  end

  add_index "recurrence_rules", ["date_recurrent_id", "date_recurrent_type"], :name => "index_recurrence_rules_on_date_recurrent"
  add_index "recurrence_rules", ["time_recurrent_id", "time_recurrent_type"], :name => "index_recurrence_rules_on_time_recurrent"

  create_table "user_agreements", :force => true do |t|
    t.string "title"
    t.text   "content"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                    :default => "", :null => false
    t.string   "encrypted_password",       :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.integer  "roles_mask"
    t.string   "mobile"
    t.string   "name"
    t.string   "mobile_verification_code"
    t.datetime "mobile_verified_at"
    t.string   "login_name"
    t.integer  "company_id"
  end

  add_index "users", ["company_id"], :name => "index_users_on_company_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login_name"], :name => "index_users_on_login_name"
  add_index "users", ["mobile"], :name => "index_users_on_mobile"
  add_index "users", ["mobile_verified_at"], :name => "index_users_on_mobile_verified_at"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venue_inventories", :force => true do |t|
    t.integer  "capacity"
    t.integer  "gym_id"
    t.integer  "venue_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "venue_inventories", ["gym_id"], :name => "index_venue_inventories_on_gym_id"
  add_index "venue_inventories", ["venue_type_id"], :name => "index_venue_inventories_on_venue_type_id"

  create_table "venue_rules", :force => true do |t|
    t.string   "type"
    t.integer  "activity_id"
    t.text     "settings"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "venue_rules", ["activity_id"], :name => "index_venue_rules_on_activity_id"

  create_table "venue_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "venues", :force => true do |t|
    t.datetime "start_at"
    t.datetime "stop_at"
    t.integer  "count_on_hand"
    t.integer  "activity_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.integer  "capacity"
    t.decimal  "price",         :precision => 8, :scale => 2
    t.decimal  "member_price",  :precision => 8, :scale => 2
    t.boolean  "active"
  end

  add_index "venues", ["active"], :name => "index_venues_on_active"
  add_index "venues", ["activity_id"], :name => "index_venues_on_activity_id"

end
