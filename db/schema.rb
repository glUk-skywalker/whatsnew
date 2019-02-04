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

ActiveRecord::Schema.define(version: 20190204100538) do

  create_table "builds", force: :cascade do |t|
    t.string   "number",        limit: 255
    t.string   "tag",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bug_list",      limit: 5000
    t.datetime "whatsnew_time"
    t.boolean  "processed",                  default: false
    t.string   "task_list",     limit: 5000
  end

  create_table "testers", force: :cascade do |t|
    t.string   "first_name", limit: 255, null: false
    t.string   "last_name",  limit: 255, null: false
    t.string   "email",      limit: 255, null: false
    t.string   "phab_id",    limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
