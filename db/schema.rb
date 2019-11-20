# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_20_115022) do

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "state", null: false
    t.integer "vertical_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["vertical_id"], name: "index_categories_on_vertical_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name", null: false
    t.string "state", null: false
    t.string "author", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_courses_on_category_id"
  end

  create_table "verticals", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_verticals_on_name", unique: true
  end

  add_foreign_key "categories", "verticals"
  add_foreign_key "courses", "categories"
end
