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

ActiveRecord::Schema[7.2].define(version: 2026_04_08_045341) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "social_ecological_characterizations", force: :cascade do |t|
    t.string "authors", null: false
    t.integer "year", default: 1900, null: false
    t.string "title", null: false
    t.integer "resource_type", null: false
    t.string "intitution", null: false
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
  end
end
