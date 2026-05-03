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

ActiveRecord::Schema[7.2].define(version: 2026_05_02_235712) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer "project"
    t.integer "associated_objective"
    t.integer "activity_name"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.integer "status"
    t.bigint "monthly_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "custom_select_list_id", null: false
    t.index ["custom_select_list_id"], name: "index_activities_on_custom_select_list_id"
    t.index ["monthly_report_id"], name: "index_activities_on_monthly_report_id"
  end

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

