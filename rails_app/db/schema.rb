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

ActiveRecord::Schema.define(version: 2018_11_07_030215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "number"
    t.string "previous_name_1_company_name"
    t.string "previous_name_2_company_name"
    t.string "previous_name_3_company_name"
    t.string "previous_name_4_company_name"
    t.string "previous_name_5_company_name"
    t.string "previous_name_6_company_name"
    t.string "previous_name_7_company_name"
    t.string "previous_name_8_company_name"
    t.string "previous_name_9_company_name"
    t.string "previous_name_10_company_name"
    t.index ["number"], name: "index_companies_on_number", unique: true
  end

end
