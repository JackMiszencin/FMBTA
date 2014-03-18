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

ActiveRecord::Schema.define(version: 20140318110709) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.integer  "citizen_id"
    t.decimal  "value",      precision: 14, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "citizens", force: true do |t|
    t.string   "ss_number"
    t.string   "license_number"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_of_birth"
  end

  add_index "citizens", ["ss_number"], name: "index_citizens_on_ss_number", using: :btree

  create_table "discount_templates", force: true do |t|
    t.integer "pass_template_id"
    t.integer "mode_id"
    t.decimal "markdown",         precision: 4, scale: 3, default: 1.0
    t.decimal "constant",         precision: 4, scale: 2, default: 0.0
  end

  create_table "discounts", force: true do |t|
    t.integer "pass_id"
    t.integer "mode_id"
    t.decimal "markdown", precision: 4, scale: 3, default: 1.0
    t.decimal "constant", precision: 4, scale: 2, default: 0.0
  end

  create_table "institutions", force: true do |t|
    t.string "name"
    t.string "ein"
  end

  create_table "memberships", force: true do |t|
    t.integer "citizen_id"
    t.integer "institution_id"
    t.date    "expiration"
  end

  create_table "modes", force: true do |t|
    t.string  "name"
    t.decimal "base_price", precision: 14, scale: 2
  end

  create_table "pass_templates", force: true do |t|
    t.integer "institution_id"
    t.boolean "membership_required"
    t.boolean "payment_required"
    t.integer "term"
    t.string  "term_unit"
    t.decimal "price",               precision: 14, scale: 2
    t.integer "min_age"
    t.integer "max_age"
    t.boolean "prorated",                                     default: false
  end

  create_table "passes", force: true do |t|
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "insitution_id"
  end

end
