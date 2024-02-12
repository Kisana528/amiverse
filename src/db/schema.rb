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

ActiveRecord::Schema[7.0].define(version: 17) do
  create_table "account_reaction_items", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "reaction_id", null: false
    t.bigint "item_id", null: false
    t.string "description", default: "", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_reaction_items_on_account_id"
    t.index ["item_id"], name: "index_account_reaction_items_on_item_id"
    t.index ["reaction_id"], name: "index_account_reaction_items_on_reaction_id"
  end

  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "account_id", null: false
    t.string "name", default: "", null: false
    t.string "name_id", null: false
    t.string "fediverse_id", default: "", null: false
    t.string "icon_id", default: "", null: false
    t.string "banner_id", default: "", null: false
    t.string "online_status", default: "", null: false
    t.timestamp "last_online"
    t.boolean "open_online_status", default: true, null: false
    t.boolean "authenticated", default: false, null: false
    t.boolean "public_visibility", default: true, null: false
    t.text "local_group_visibility", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "local_account_visibility", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "role", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "outsider", default: false, null: false
    t.boolean "activated", default: false, null: false
    t.boolean "administrator", default: false, null: false
    t.boolean "moderator", default: false, null: false
    t.string "email", default: "", null: false
    t.text "bio", default: "", null: false
    t.text "public_key", default: "", null: false
    t.text "private_key", default: "", null: false
    t.string "location", default: "", null: false
    t.timestamp "birthday"
    t.text "lang", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.integer "followers", default: 0, null: false
    t.integer "following", default: 0, null: false
    t.integer "items_count", default: 0, null: false
    t.text "pinned_items", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "nsfw", default: false, null: false
    t.boolean "explorable", default: false, null: false
    t.text "profile", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "achievements", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "locked", default: false, null: false
    t.boolean "silenced", default: false, null: false
    t.boolean "suspended", default: false, null: false
    t.boolean "frozen", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.text "settings", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.string "password_digest"
    t.bigint "storage_size", default: 0, null: false
    t.bigint "storage_max_size", default: 1000000000, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "name_id", "fediverse_id"], name: "index_accounts_on_account_id_and_name_id_and_fediverse_id", unique: true
    t.check_constraint "json_valid(`achievements`)", name: "achievements"
    t.check_constraint "json_valid(`lang`)", name: "lang"
    t.check_constraint "json_valid(`local_account_visibility`)", name: "local_account_visibility"
    t.check_constraint "json_valid(`local_group_visibility`)", name: "local_group_visibility"
    t.check_constraint "json_valid(`pinned_items`)", name: "pinned_items"
    t.check_constraint "json_valid(`profile`)", name: "profile"
    t.check_constraint "json_valid(`role`)", name: "role"
    t.check_constraint "json_valid(`settings`)", name: "settings"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activity_pub_delivereds", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "server_id"
    t.string "to_url"
    t.string "digest"
    t.text "to_be_signed"
    t.text "signature"
    t.text "statement"
    t.text "content", size: :long, collation: "utf8mb4_bin"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "json_valid(`content`)", name: "content"
  end

  create_table "activity_pub_receiveds", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "server_id"
    t.string "received_at"
    t.text "headers", size: :long, collation: "utf8mb4_bin"
    t.text "body", size: :long, collation: "utf8mb4_bin"
    t.text "context", size: :long, collation: "utf8mb4_bin"
    t.string "fediverse_id"
    t.string "account_id"
    t.string "activity_type"
    t.text "object", size: :long, collation: "utf8mb4_bin"
    t.text "summary"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "json_valid(`body`)", name: "body"
    t.check_constraint "json_valid(`context`)", name: "context"
    t.check_constraint "json_valid(`headers`)", name: "headers"
    t.check_constraint "json_valid(`object`)", name: "object"
  end

  create_table "activity_pub_servers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "server_id", default: "", null: false
    t.string "name", default: "", null: false
    t.string "host", default: "", null: false
    t.text "description", default: "", null: false
    t.string "icon_url", default: "", null: false
    t.string "favicon_id", default: "", null: false
    t.integer "accounts", default: 0, null: false
    t.integer "items", default: 0, null: false
    t.integer "followers", default: 0, null: false
    t.integer "following", default: 0, null: false
    t.string "memo", default: "", null: false
    t.string "software_name", default: "", null: false
    t.string "software_version", default: "", null: false
    t.boolean "open_registrations", default: false, null: false
    t.boolean "not_responding", default: false, null: false
    t.boolean "blocked", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.string "theme_color", default: "", null: false
    t.string "maintainer_name", default: "", null: false
    t.string "maintainer_email", default: "", null: false
    t.timestamp "first_retrieved_at"
    t.timestamp "last_received_at"
    t.timestamp "info_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["server_id", "host"], name: "index_activity_pub_servers_on_server_id_and_host", unique: true
  end

  create_table "follows", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "follow_to_id", default: "", null: false
    t.string "follow_from_id", default: "", null: false
    t.string "uid", default: "", null: false
    t.boolean "accepted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "image_id", null: false
    t.string "uuid", null: false
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.boolean "nsfw", default: false, null: false
    t.string "nsfw_message", default: "", null: false
    t.boolean "public_visibility", default: true, null: false
    t.text "local_group_visibility", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "local_account_visibility", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_images_on_account_id"
    t.index ["image_id", "uuid"], name: "index_images_on_image_id_and_uuid", unique: true
    t.check_constraint "json_valid(`local_account_visibility`)", name: "local_account_visibility"
    t.check_constraint "json_valid(`local_group_visibility`)", name: "local_group_visibility"
  end

  create_table "invitations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", default: "", null: false
    t.string "invitation_code", null: false
    t.integer "uses", default: 0, null: false
    t.integer "max_uses", default: 1, null: false
    t.timestamp "expires_at"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_invitations_on_account_id"
    t.index ["invitation_code"], name: "index_invitations_on_invitation_code", unique: true
  end

  create_table "item_images", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "image_id", null: false
    t.string "description", default: "", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_id"], name: "index_item_images_on_image_id"
    t.index ["item_id"], name: "index_item_images_on_item_id"
  end

  create_table "item_videos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "video_id", null: false
    t.string "description", default: "", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_videos_on_item_id"
    t.index ["video_id"], name: "index_item_videos_on_video_id"
  end

  create_table "items", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "item_id", null: false
    t.string "uuid", null: false
    t.string "item_type", default: "", null: false
    t.string "reply_item_id", default: "", null: false
    t.string "quote_item_id", default: "", null: false
    t.text "meta", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "content", default: "", null: false
    t.boolean "markdown", default: false, null: false
    t.boolean "html", default: false, null: false
    t.boolean "cw", default: false, null: false
    t.string "cw_message", default: "", null: false
    t.text "version", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_items_on_account_id"
    t.index ["item_id", "uuid"], name: "index_items_on_item_id_and_uuid", unique: true
    t.check_constraint "json_valid(`meta`)", name: "meta"
    t.check_constraint "json_valid(`version`)", name: "version"
  end

  create_table "quotes", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "quote_to_id", default: "", null: false
    t.string "quote_from_id", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reactions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "reaction_id", null: false
    t.string "reaction_type", default: "", null: false
    t.string "content", default: "", null: false
    t.string "description", default: "", null: false
    t.string "category", default: "", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_reactions_on_account_id"
  end

  create_table "replies", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "reply_to_id", default: "", null: false
    t.string "reply_from_id", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.string "remote_ip", default: "", null: false
    t.string "user_agent", default: "", null: false
    t.string "uuid", default: "", null: false
    t.string "session_digest", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_sessions_on_account_id"
    t.index ["uuid"], name: "index_sessions_on_uuid", unique: true
  end

  create_table "videos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "video_id", null: false
    t.string "uuid", null: false
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.boolean "nsfw", default: false, null: false
    t.string "nsfw_message", default: "", null: false
    t.boolean "public_visibility", default: true, null: false
    t.text "local_group_visibility", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "local_account_visibility", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_videos_on_account_id"
    t.index ["video_id", "uuid"], name: "index_videos_on_video_id_and_uuid", unique: true
    t.check_constraint "json_valid(`local_account_visibility`)", name: "local_account_visibility"
    t.check_constraint "json_valid(`local_group_visibility`)", name: "local_group_visibility"
  end

  add_foreign_key "account_reaction_items", "accounts"
  add_foreign_key "account_reaction_items", "items"
  add_foreign_key "account_reaction_items", "reactions"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "images", "accounts"
  add_foreign_key "invitations", "accounts"
  add_foreign_key "item_images", "images"
  add_foreign_key "item_images", "items"
  add_foreign_key "item_videos", "items"
  add_foreign_key "item_videos", "videos"
  add_foreign_key "items", "accounts"
  add_foreign_key "reactions", "accounts"
  add_foreign_key "sessions", "accounts"
  add_foreign_key "videos", "accounts"
end
