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

ActiveRecord::Schema.define(version: 2019_02_15_025553) do

  create_table "images", force: :cascade do |t|
    t.string "alt"
    t.string "hint"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stories", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.string "image"
    t.integer "reads_count", default: 0
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "comments_count", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.string "profile_image"
    t.string "name", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmation_terms", default: false
    t.boolean "confirmation_privacy", default: false
    t.boolean "confirmation_mailing", default: false
    t.boolean "admin", default: false
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

end
