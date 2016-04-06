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

ActiveRecord::Schema.define(version: 20160405024152) do

  create_table "activities", force: :cascade do |t|
    t.string "name"
  end

  create_table "activity_events", force: :cascade do |t|
    t.integer "activity_id"
    t.integer "event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string  "name"
    t.integer "user_id"
    t.text    "details"
  end

  create_table "participants", force: :cascade do |t|
    t.integer "event_id"
  end

  create_table "user_participants", force: :cascade do |t|
    t.integer "user_id"
    t.integer "participant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
  end

end
