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

ActiveRecord::Schema.define(version: 2019_06_10_054919) do

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "commentable_type", null: false
    t.integer "commentable_id", null: false
    t.text "body"
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "hashtags", force: :cascade do |t|
    t.integer "suggestion_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["suggestion_id", "name"], name: "index_hashtags_on_suggestion_id_and_name", unique: true
    t.index ["suggestion_id"], name: "index_hashtags_on_suggestion_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "alt"
    t.string "hint"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kommentables", force: :cascade do |t|
    t.integer "comments_count", default: 0
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_kommentables_on_slug", unique: true
  end

  create_table "likes", force: :cascade do |t|
    t.string "likable_type", null: false
    t.integer "likable_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["likable_type", "likable_id"], name: "index_likes_on_likable_type_and_likable_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "notices", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.integer "comments_count", default: 0
    t.integer "reads_count", default: 0
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_notices_on_user_id"
  end

  create_table "snapshots", force: :cascade do |t|
    t.string "image", null: false
    t.text "body", null: false
    t.string "area_code", null: false
    t.integer "comments_count", default: 0
    t.integer "reads_count", default: 0
    t.integer "likes_count", default: 0
    t.integer "user_id", null: false
    t.string "real_user_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_snapshots_on_user_id"
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
    t.integer "user_id", null: false
    t.boolean "pin", default: false
    t.index ["user_id"], name: "index_stories_on_user_id"
  end

  create_table "suggestions", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.string "image"
    t.string "area_code"
    t.string "category"
    t.text "raw_hashtags"
    t.integer "comments_count", default: 0
    t.integer "reads_count", default: 0
    t.integer "likes_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "real_user_name"
    t.index ["user_id"], name: "index_suggestions_on_user_id"
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

  create_table "words", force: :cascade do |t|
    t.string "text", null: false
    t.integer "count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
