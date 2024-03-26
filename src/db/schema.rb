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

ActiveRecord::Schema[7.0].define(version: 992) do
  create_table "Polls", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "survey_id", null: false
    t.text "content", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_Polls_on_account_id"
    t.index ["survey_id"], name: "index_Polls_on_survey_id"
    t.check_constraint "json_valid(`content`)", name: "content"
  end

  create_table "accounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.string "name_id", null: false
    t.string "activitypub_id", default: "", null: false
    t.string "icon_id", default: "", null: false
    t.string "banner_id", default: "", null: false
    t.bigint "followers_counter", default: 0, null: false
    t.bigint "following_counter", default: 0, null: false
    t.bigint "items_counter", default: 0, null: false
    t.bigint "reactions_counter", default: 0, null: false
    t.text "pinned_items", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "meta", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "cache", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "achievements", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "online", default: true, null: false
    t.datetime "last_online"
    t.boolean "invisible_online", default: false, null: false
    t.boolean "foreigner", default: false, null: false
    t.boolean "activated", default: false, null: false
    t.boolean "administrator", default: false, null: false
    t.boolean "moderator", default: false, null: false
    t.boolean "bot", default: false, null: false
    t.boolean "commercial", default: false, null: false
    t.string "kind", default: "", null: false
    t.boolean "discoverable", default: true, null: false
    t.boolean "manually_approves_followers", default: false, null: false
    t.text "summary", default: "", null: false
    t.text "public_key", default: "", null: false
    t.text "private_key", default: "", null: false
    t.string "location", default: "", null: false
    t.datetime "birthday"
    t.text "languages", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.string "email", default: "", null: false
    t.boolean "locked", default: false, null: false
    t.boolean "silenced", default: false, null: false
    t.boolean "suspended", default: false, null: false
    t.boolean "frozen", default: false, null: false
    t.text "settings", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.bigint "storage_size", default: 0, null: false
    t.bigint "storage_max_size", default: 1000000000, null: false
    t.string "password_digest"
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aid", "name_id", "activitypub_id"], name: "index_accounts_on_aid_and_name_id_and_activitypub_id", unique: true
    t.check_constraint "json_valid(`achievements`)", name: "achievements"
    t.check_constraint "json_valid(`cache`)", name: "cache"
    t.check_constraint "json_valid(`languages`)", name: "languages"
    t.check_constraint "json_valid(`meta`)", name: "meta"
    t.check_constraint "json_valid(`pinned_items`)", name: "pinned_items"
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
    t.string "activitypub_id"
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

  create_table "applications", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.bigint "players", default: 0, null: false
    t.bigint "max_players", default: 8, null: false
    t.text "script", default: "", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_applications_on_account_id"
    t.index ["aid"], name: "index_applications_on_aid", unique: true
  end

  create_table "audios", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.boolean "sensitive", default: false, null: false
    t.string "warning_message", default: "", null: false
    t.string "kind", default: "", null: false
    t.text "meta", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "cache", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "references", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_audios_on_account_id"
    t.index ["aid"], name: "index_audios_on_aid", unique: true
    t.check_constraint "json_valid(`cache`)", name: "cache"
    t.check_constraint "json_valid(`meta`)", name: "meta"
    t.check_constraint "json_valid(`references`)", name: "references"
  end

  create_table "bills", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "uuid", null: false
    t.string "kind", default: "", null: false
    t.string "object", default: "", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.string "amount", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_bills_on_account_id"
  end

  create_table "blocks", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blocked", null: false
    t.bigint "blocker", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked"], name: "fk_rails_09e091176d"
    t.index ["blocker"], name: "fk_rails_0d53fdd4e5"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.bigint "counter", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aid"], name: "index_categories_on_aid", unique: true
  end

  create_table "emoji_categories", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "emoji_id", null: false
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_emoji_categories_on_category_id"
    t.index ["emoji_id"], name: "index_emoji_categories_on_emoji_id"
  end

  create_table "emoji_tags", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "emoji_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["emoji_id"], name: "index_emoji_tags_on_emoji_id"
    t.index ["tag_id"], name: "index_emoji_tags_on_tag_id"
  end

  create_table "emojis", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "emoji_type", default: "", null: false
    t.string "content", default: "", null: false
    t.string "description", default: "", null: false
    t.boolean "sensitive", default: false, null: false
    t.boolean "local", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_emojis_on_account_id"
    t.index ["aid"], name: "index_emojis_on_aid", unique: true
  end

  create_table "entries", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_entries_on_account_id"
    t.index ["group_id"], name: "index_entries_on_group_id"
  end

  create_table "follows", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "followed", null: false
    t.bigint "follower", null: false
    t.string "uuid", default: "", null: false
    t.boolean "accepted", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed"], name: "fk_rails_7b60022071"
    t.index ["follower"], name: "fk_rails_2712f8dae3"
  end

  create_table "groups", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.string "description", default: "", null: false
    t.integer "counter", default: 0, null: false
    t.boolean "private", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_groups_on_account_id"
    t.index ["aid"], name: "index_groups_on_aid", unique: true
  end

  create_table "images", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.boolean "sensitive", default: false, null: false
    t.string "warning_message", default: "", null: false
    t.string "kind", default: "", null: false
    t.text "meta", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "cache", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "references", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_images_on_account_id"
    t.index ["aid"], name: "index_images_on_aid", unique: true
    t.check_constraint "json_valid(`cache`)", name: "cache"
    t.check_constraint "json_valid(`meta`)", name: "meta"
    t.check_constraint "json_valid(`references`)", name: "references"
  end

  create_table "invitations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "uuid", null: false
    t.string "name", default: "", null: false
    t.string "code", null: false
    t.integer "uses", default: 0, null: false
    t.integer "max_uses", default: 1, null: false
    t.datetime "expires_at"
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_invitations_on_account_id"
    t.index ["code"], name: "index_invitations_on_code", unique: true
  end

  create_table "item_tags", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_tags_on_item_id"
    t.index ["tag_id"], name: "index_item_tags_on_tag_id"
  end

  create_table "item_topics", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "topic_id", null: false
    t.integer "score", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_topics_on_item_id"
    t.index ["topic_id"], name: "index_item_topics_on_topic_id"
  end

  create_table "items", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.text "content", default: "", null: false
    t.text "images", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "audios", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "videos", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "sensitive", default: false, null: false
    t.string "warning_message", default: "", null: false
    t.string "kind", default: "", null: false
    t.text "meta", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "cache", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "foreign", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_items_on_account_id"
    t.index ["aid"], name: "index_items_on_aid", unique: true
    t.check_constraint "json_valid(`audios`)", name: "audios"
    t.check_constraint "json_valid(`cache`)", name: "cache"
    t.check_constraint "json_valid(`images`)", name: "images"
    t.check_constraint "json_valid(`meta`)", name: "meta"
    t.check_constraint "json_valid(`videos`)", name: "videos"
  end

  create_table "lists", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.integer "counter", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_lists_on_account_id"
    t.index ["aid"], name: "index_lists_on_aid", unique: true
  end

  create_table "locations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "uuid", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_locations_on_account_id"
  end

  create_table "members", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "membership_id", null: false
    t.string "uuid", null: false
    t.datetime "expires_at"
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_members_on_account_id"
    t.index ["membership_id"], name: "index_members_on_membership_id"
  end

  create_table "memberships", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "uuid", null: false
    t.integer "counter", default: 0, null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_memberships_on_account_id"
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "group_id", null: false
    t.string "uuid", null: false
    t.string "kind", default: "", null: false
    t.text "content", default: "", null: false
    t.integer "read", default: 0, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_messages_on_account_id"
    t.index ["group_id"], name: "index_messages_on_group_id"
  end

  create_table "mutes", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "muted", null: false
    t.bigint "muter", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["muted"], name: "fk_rails_bd2bac489c"
    t.index ["muter"], name: "fk_rails_9f098a6341"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "uuid", null: false
    t.string "kind", default: "", null: false
    t.string "object", default: "", null: false
    t.string "message", default: "", null: false
    t.boolean "read", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_notifications_on_account_id"
  end

  create_table "places", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "uuid", null: false
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "counter", default: 0, null: false
    t.string "name", default: "", null: false
    t.boolean "private", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_places_on_account_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "uuid", null: false
    t.integer "counter", default: 0, null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.text "content", default: "", null: false
    t.integer "purchases", default: 0, null: false
    t.integer "max_purchases", default: 1, null: false
    t.integer "price", default: 0, null: false
    t.datetime "expires_at"
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_products_on_account_id"
  end

  create_table "purchases", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "product_id", null: false
    t.string "uuid", null: false
    t.integer "price", default: 0, null: false
    t.integer "amount", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_purchases_on_account_id"
    t.index ["product_id"], name: "index_purchases_on_product_id"
  end

  create_table "quotes", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "quoted", null: false
    t.bigint "quoter", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quoted"], name: "fk_rails_87ced17c39"
    t.index ["quoter"], name: "fk_rails_616dc58d04"
  end

  create_table "reactions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "emoji_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_reactions_on_account_id"
    t.index ["emoji_id"], name: "index_reactions_on_emoji_id"
    t.index ["item_id"], name: "index_reactions_on_item_id"
  end

  create_table "read_items", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_read_items_on_account_id"
    t.index ["item_id"], name: "index_read_items_on_item_id"
  end

  create_table "read_messages", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "message_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_read_messages_on_account_id"
    t.index ["message_id"], name: "index_read_messages_on_message_id"
  end

  create_table "registrations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "list", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_registrations_on_account_id"
  end

  create_table "replies", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "replied", null: false
    t.bigint "replier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["replied"], name: "fk_rails_7f82de0917"
    t.index ["replier"], name: "fk_rails_2001645403"
  end

  create_table "server_Logs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "content", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "server_data", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "content", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", default: "", null: false
    t.string "ip_address", default: "", null: false
    t.string "user_agent", default: "", null: false
    t.string "uuid", null: false
    t.string "session_digest", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_sessions_on_account_id"
    t.index ["uuid"], name: "index_sessions_on_uuid", unique: true
  end

  create_table "subscribers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "subscription_id", null: false
    t.string "uuid", null: false
    t.datetime "expires_at"
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_subscribers_on_account_id"
    t.index ["subscription_id"], name: "index_subscribers_on_subscription_id"
  end

  create_table "subscriptions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "uuid", null: false
    t.integer "counter", default: 0, null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_subscriptions_on_account_id"
  end

  create_table "surveys", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.integer "counter", default: 0, null: false
    t.boolean "multiple", default: false, null: false
    t.boolean "eternal", default: false, null: false
    t.text "content", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.check_constraint "json_valid(`content`)", name: "content"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.bigint "counter", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aid"], name: "index_tags_on_aid", unique: true
  end

  create_table "topics", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.bigint "counter", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aid"], name: "index_topics_on_aid", unique: true
  end

  create_table "used_invitations", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "invitation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_used_invitations_on_account_id"
    t.index ["invitation_id"], name: "index_used_invitations_on_invitation_id"
  end

  create_table "videos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.boolean "sensitive", default: false, null: false
    t.string "warning_message", default: "", null: false
    t.string "kind", default: "", null: false
    t.text "meta", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "cache", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.text "references", size: :long, default: "[]", null: false, collation: "utf8mb4_bin"
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_videos_on_account_id"
    t.index ["aid"], name: "index_videos_on_aid", unique: true
    t.check_constraint "json_valid(`cache`)", name: "cache"
    t.check_constraint "json_valid(`meta`)", name: "meta"
    t.check_constraint "json_valid(`references`)", name: "references"
  end

  create_table "wallets", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.string "currency", default: "", null: false
    t.text "wallet", default: "", null: false
    t.bigint "amount", default: 0, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_wallets_on_account_id"
    t.index ["aid"], name: "index_wallets_on_aid", unique: true
  end

  create_table "worlds", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "aid", null: false
    t.string "name", default: "", null: false
    t.text "description", default: "", null: false
    t.bigint "players", default: 0, null: false
    t.bigint "max_players", default: 8, null: false
    t.boolean "deleted", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_worlds_on_account_id"
    t.index ["aid"], name: "index_worlds_on_aid", unique: true
  end

  add_foreign_key "Polls", "accounts"
  add_foreign_key "Polls", "surveys"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applications", "accounts"
  add_foreign_key "audios", "accounts"
  add_foreign_key "bills", "accounts"
  add_foreign_key "blocks", "accounts", column: "blocked"
  add_foreign_key "blocks", "accounts", column: "blocker"
  add_foreign_key "emoji_categories", "categories"
  add_foreign_key "emoji_categories", "emojis"
  add_foreign_key "emoji_tags", "emojis"
  add_foreign_key "emoji_tags", "tags"
  add_foreign_key "emojis", "accounts"
  add_foreign_key "entries", "accounts"
  add_foreign_key "entries", "groups"
  add_foreign_key "follows", "accounts", column: "followed"
  add_foreign_key "follows", "accounts", column: "follower"
  add_foreign_key "groups", "accounts"
  add_foreign_key "images", "accounts"
  add_foreign_key "invitations", "accounts"
  add_foreign_key "item_tags", "items"
  add_foreign_key "item_tags", "tags"
  add_foreign_key "item_topics", "items"
  add_foreign_key "item_topics", "topics"
  add_foreign_key "items", "accounts"
  add_foreign_key "lists", "accounts"
  add_foreign_key "locations", "accounts"
  add_foreign_key "members", "accounts"
  add_foreign_key "members", "memberships"
  add_foreign_key "memberships", "accounts"
  add_foreign_key "messages", "accounts"
  add_foreign_key "messages", "groups"
  add_foreign_key "mutes", "accounts", column: "muted"
  add_foreign_key "mutes", "accounts", column: "muter"
  add_foreign_key "notifications", "accounts"
  add_foreign_key "places", "accounts"
  add_foreign_key "products", "accounts"
  add_foreign_key "purchases", "accounts"
  add_foreign_key "purchases", "products"
  add_foreign_key "quotes", "items", column: "quoted"
  add_foreign_key "quotes", "items", column: "quoter"
  add_foreign_key "reactions", "accounts"
  add_foreign_key "reactions", "emojis"
  add_foreign_key "reactions", "items"
  add_foreign_key "read_items", "accounts"
  add_foreign_key "read_items", "items"
  add_foreign_key "read_messages", "accounts"
  add_foreign_key "read_messages", "messages"
  add_foreign_key "registrations", "accounts"
  add_foreign_key "replies", "items", column: "replied"
  add_foreign_key "replies", "items", column: "replier"
  add_foreign_key "sessions", "accounts"
  add_foreign_key "subscribers", "accounts"
  add_foreign_key "subscribers", "subscriptions"
  add_foreign_key "subscriptions", "accounts"
  add_foreign_key "used_invitations", "accounts"
  add_foreign_key "used_invitations", "invitations"
  add_foreign_key "videos", "accounts"
  add_foreign_key "wallets", "accounts"
  add_foreign_key "worlds", "accounts"
end
