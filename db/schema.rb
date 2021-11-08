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

ActiveRecord::Schema.define(version: 2021_11_08_011009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "album_labels", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "album_pointers", force: :cascade do |t|
    t.string "artist_name"
    t.string "album_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "albums", force: :cascade do |t|
    t.string "name", null: false
    t.integer "disc_number"
    t.integer "num_discs"
    t.integer "num_tracks"
    t.boolean "is_compilation", default: false, null: false
    t.bigint "artist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_albums_on_artist_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "genre_id"
    t.string "sort_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_artists_on_genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playlist_tracks", force: :cascade do |t|
    t.bigint "playlist_id"
    t.bigint "track_id"
    t.integer "ordering", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_playlist_tracks_on_playlist_id"
    t.index ["track_id"], name: "index_playlist_tracks_on_track_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name", null: false
    t.string "persistent_id"
    t.string "parent_persistent_id"
    t.string "description"
    t.boolean "is_folder", default: false, null: false
    t.boolean "is_smart_list", default: false, null: false
    t.boolean "is_master", default: false, null: false
    t.boolean "is_visible", default: true, null: false
    t.boolean "is_all_items", default: false, null: false
    t.integer "distinguished_kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "track_ratings", force: :cascade do |t|
    t.bigint "track_id"
    t.integer "value"
    t.boolean "is_computed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id"], name: "index_track_ratings_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name", null: false
    t.integer "total_time"
    t.integer "track_number"
    t.integer "year"
    t.bigint "artist_id"
    t.bigint "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_tracks_on_album_id"
    t.index ["artist_id"], name: "index_tracks_on_artist_id"
  end

  add_foreign_key "playlist_tracks", "playlists"
  add_foreign_key "playlist_tracks", "tracks"
  add_foreign_key "track_ratings", "tracks"
  add_foreign_key "tracks", "albums"
  add_foreign_key "tracks", "artists"
end
