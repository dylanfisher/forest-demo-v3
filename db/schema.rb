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

ActiveRecord::Schema[7.0].define(version: 2023_05_31_192136) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "base_blocks", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "block_kinds", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "record_type"
    t.index ["category"], name: "index_block_kinds_on_category"
    t.index ["name"], name: "index_block_kinds_on_name", unique: true
    t.index ["record_type"], name: "index_block_kinds_on_record_type"
  end

  create_table "block_layouts", force: :cascade do |t|
    t.string "slug"
    t.string "display_name"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["slug"], name: "index_block_layouts_on_slug", unique: true
  end

  create_table "block_slots", id: :serial, force: :cascade do |t|
    t.string "block_type"
    t.integer "block_id"
    t.integer "block_kind_id"
    t.string "block_record_type"
    t.integer "block_record_id"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "block_layout_id"
    t.index ["block_kind_id"], name: "index_block_slots_on_block_kind_id"
    t.index ["block_layout_id"], name: "index_block_slots_on_block_layout_id"
    t.index ["block_record_type", "block_record_id"], name: "index_block_slots_on_block_record_type_and_block_record_id"
    t.index ["block_type", "block_id"], name: "index_block_slots_on_block_type_and_block_id"
  end

  create_table "media_items", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "caption"
    t.string "alternative_text"
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "media_item_status", default: 0
    t.jsonb "attachment_data"
    t.float "point_of_interest_x", default: 50.0
    t.float "point_of_interest_y", default: 50.0
    t.string "attachment_content_type"
    t.boolean "retain_source", default: false, null: false
    t.bigint "poster_image_id"
    t.jsonb "video_data"
    t.index "((attachment_data -> 'derivatives'::text))", name: "index_media_items_on_attachment_data_derivatives", using: :gin
    t.index ["attachment_content_type"], name: "index_media_items_on_attachment_content_type"
    t.index ["attachment_data"], name: "index_media_items_on_attachment_data", using: :gin
    t.index ["created_at"], name: "index_media_items_on_created_at"
    t.index ["media_item_status"], name: "index_media_items_on_media_item_status"
    t.index ["poster_image_id"], name: "index_media_items_on_poster_image_id"
    t.index ["slug"], name: "index_media_items_on_slug", unique: true
  end

  create_table "menus", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "structure"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["slug"], name: "index_menus_on_slug", unique: true
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "path"
    t.integer "status", default: 1, null: false
    t.datetime "scheduled_date", precision: nil
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "featured_image_id"
    t.integer "parent_page_id"
    t.string "redirect"
    t.jsonb "blockable_metadata", default: {}
    t.string "seo_title"
    t.index ["blockable_metadata"], name: "index_pages_on_blockable_metadata", using: :gin
    t.index ["featured_image_id"], name: "index_pages_on_featured_image_id"
    t.index ["parent_page_id"], name: "index_pages_on_parent_page_id"
    t.index ["path"], name: "index_pages_on_path", unique: true
    t.index ["slug"], name: "index_pages_on_slug"
    t.index ["status"], name: "index_pages_on_status"
  end

  create_table "redirects", force: :cascade do |t|
    t.string "name"
    t.string "from_path"
    t.string "to_path"
    t.string "redirect_type"
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_path"], name: "index_redirects_on_from_path"
    t.index ["status", "from_path"], name: "index_redirects_on_status_and_from_path"
    t.index ["status"], name: "index_redirects_on_status"
    t.index ["to_path"], name: "index_redirects_on_to_path"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "value"
    t.text "description"
    t.string "value_type", default: "text"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "locale"
    t.integer "setting_status", default: 0
    t.index ["locale", "slug"], name: "index_settings_on_locale_and_slug", unique: true
    t.index ["locale"], name: "index_settings_on_locale"
    t.index ["setting_status"], name: "index_settings_on_setting_status"
  end

  create_table "user_groups", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_user_groups_on_name", unique: true
  end

  create_table "user_groups_users", id: false, force: :cascade do |t|
    t.integer "user_group_id", null: false
    t.integer "user_id", null: false
    t.index ["user_group_id", "user_id"], name: "index_user_groups_users_on_user_group_id_and_user_id"
    t.index ["user_id", "user_group_id"], name: "index_user_groups_users_on_user_id_and_user_group_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "first_name"
    t.string "last_name"
    t.string "slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "block_slots", "block_kinds"
  add_foreign_key "block_slots", "block_layouts"
  add_foreign_key "media_items", "media_items", column: "poster_image_id"
end
