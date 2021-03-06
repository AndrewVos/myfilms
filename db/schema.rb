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

ActiveRecord::Schema.define(version: 20170708182459) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "discovers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_discovers_on_user_id"
  end

  create_table "movies", force: :cascade do |t|
    t.integer "tmdb_id", null: false
    t.boolean "adult"
    t.string "backdrop_path"
    t.string "original_language"
    t.string "original_title"
    t.string "poster_path"
    t.date "release_date"
    t.string "title"
    t.string "overview"
    t.boolean "video"
    t.decimal "vote_average"
    t.bigint "vote_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "budget"
    t.json "genres"
    t.string "imdb_id"
    t.decimal "popularity"
    t.bigint "revenue"
    t.integer "runtime"
    t.json "spoken_languages"
    t.string "status"
    t.string "tagline"
    t.json "videos"
    t.boolean "discoverable", default: false, null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "movie_id", null: false
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "want_to_watches", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_want_to_watches_on_user_id"
  end

end
