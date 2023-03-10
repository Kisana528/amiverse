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

ActiveRecord::Schema[7.0].define(version: 2023_03_06_083512) do
  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "account_id", null: false
    t.string "name", default: "", null: false
    t.string "name_id", null: false
    t.string "online_status", default: "", null: false
    t.timestamp "last_online"
    t.boolean "open_online_status", default: true, null: false
    t.boolean "authenticated", default: false, null: false
    t.boolean "public_visibility", default: true, null: false
    t.text "local_group_visibility", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "local_account_visibility", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "role", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "activated", default: false, null: false
    t.boolean "administrator", default: false, null: false
    t.boolean "moderator", default: false, null: false
    t.string "email", default: "", null: false
    t.string "bio", default: "", null: false
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
    t.string "remember_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_accounts_on_account_id"
    t.index ["email"], name: "index_accounts_on_email"
    t.index ["name_id"], name: "index_accounts_on_name_id"
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
    t.index ["invitation_code"], name: "index_invitations_on_invitation_code"
  end

  create_table "items", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "item_id", null: false
    t.string "uuid", null: false
    t.string "item_type", default: "", null: false
    t.text "flow", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "meta", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.string "content", default: "", null: false
    t.boolean "nsfw", default: false, null: false
    t.boolean "cw", default: false, null: false
    t.text "version", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "deleted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_items_on_account_id"
    t.index ["item_id"], name: "index_items_on_item_id"
    t.index ["uuid"], name: "index_items_on_uuid"
    t.check_constraint "json_valid(`flow`)", name: "flow"
    t.check_constraint "json_valid(`meta`)", name: "meta"
    t.check_constraint "json_valid(`version`)", name: "version"
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
    t.index ["uuid"], name: "index_sessions_on_uuid"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "invitations", "accounts"
  add_foreign_key "items", "accounts"
  add_foreign_key "sessions", "accounts"
end
