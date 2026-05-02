# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_05_02_022745) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actors", force: :cascade do |t|
    t.integer "actor_type"
    t.string "name"
    t.integer "territorial_level"
    t.string "municipality"
    t.integer "coverage"
    t.integer "action_field"
    t.integer "action_area"
    t.string "what_are_they_doing"
    t.boolean "monitoring_experience"
    t.integer "experience_type"
    t.integer "participation_level"
    t.integer "relationship"
    t.string "justification"
    t.integer "interaction_type"
    t.string "purpose"
    t.string "topics"
    t.integer "priority"
    t.string "contact_name"
    t.string "contact_position"
    t.string "contact_phone"
    t.string "contact_email"
    t.string "url"
    t.bigint "responsible_id", null: false
    t.integer "management_status"
    t.date "contact_date"
    t.string "contact_source"
    t.string "comments"
    t.integer "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["responsible_id"], name: "index_actors_on_responsible_id"
  end

  create_table "custom_option_lists", force: :cascade do |t|
    t.bigint "custom_select_list_id", null: false
    t.string "model_field", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_select_list_id"], name: "index_custom_option_lists_on_custom_select_list_id"
  end

  create_table "custom_options", force: :cascade do |t|
    t.bigint "custom_option_list_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_option_list_id"], name: "index_custom_options_on_custom_option_list_id"
  end

  create_table "custom_select_lists", force: :cascade do |t|
    t.string "model_name_association"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monthly_reports", force: :cascade do |t|
    t.string "date_period"
    t.bigint "user_id", null: false
    t.integer "component"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_monthly_reports_on_user_id"
  end

  create_table "social_ecological_characterizations", force: :cascade do |t|
    t.string "authors", null: false
    t.integer "year", default: 1900, null: false
    t.string "title", null: false
    t.integer "resource_type", null: false
    t.string "institution", null: false
    t.string "url", null: false
    t.integer "access_level", null: false
    t.integer "geographic_area", null: false
    t.integer "spatial_coverage", null: false
    t.integer "analysis_scale", null: false
    t.string "study_period", null: false
    t.string "study_objective", null: false
    t.integer "approach", null: false
    t.string "general_methodology_used", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_file"
    t.bigint "user_id", null: false
    t.integer "code", default: 0, null: false
    t.bigint "custom_select_list_id", null: false
    t.index ["custom_select_list_id"], name: "idx_on_custom_select_list_id_274b36b3ff"
    t.index ["user_id"], name: "index_social_ecological_characterizations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "actors", "users", column: "responsible_id"
  add_foreign_key "custom_option_lists", "custom_select_lists"
  add_foreign_key "custom_options", "custom_option_lists"
  add_foreign_key "monthly_reports", "users"
  add_foreign_key "social_ecological_characterizations", "custom_select_lists"
  add_foreign_key "social_ecological_characterizations", "users"
end
