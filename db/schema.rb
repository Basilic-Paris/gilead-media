# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_11_152124) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "contacts", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "contactable_type"
    t.bigint "contactable_id"
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id"
  end

  create_table "document_folders", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "folder_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["document_id"], name: "index_document_folders_on_document_id"
    t.index ["folder_id"], name: "index_document_folders_on_folder_id"
  end

  create_table "document_shared_lists", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "shared_list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["document_id"], name: "index_document_shared_lists_on_document_id"
    t.index ["shared_list_id"], name: "index_document_shared_lists_on_shared_list_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.string "language"
    t.text "usage"
    t.datetime "validation_at"
    t.string "format"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "folder_shared_lists", force: :cascade do |t|
    t.bigint "folder_id", null: false
    t.bigint "shared_list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["folder_id"], name: "index_folder_shared_lists_on_folder_id"
    t.index ["shared_list_id"], name: "index_folder_shared_lists_on_shared_list_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.string "password_salt"
    t.datetime "created_at"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "shared_documents", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "aasm_state"
    t.index ["document_id"], name: "index_shared_documents_on_document_id"
  end

  create_table "shared_folders", force: :cascade do |t|
    t.bigint "shared_list_id", null: false
    t.bigint "folder_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["folder_id"], name: "index_shared_folders_on_folder_id"
    t.index ["shared_list_id"], name: "index_shared_folders_on_shared_list_id"
  end

  create_table "shared_lists", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "aasm_state"
    t.date "validity"
    t.boolean "download"
    t.string "code"
    t.index ["user_id"], name: "index_shared_lists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin", default: false
    t.datetime "password_changed_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "document_folders", "documents"
  add_foreign_key "document_folders", "folders"
  add_foreign_key "document_shared_lists", "documents"
  add_foreign_key "document_shared_lists", "shared_lists"
  add_foreign_key "folder_shared_lists", "folders"
  add_foreign_key "folder_shared_lists", "shared_lists"
  add_foreign_key "shared_documents", "documents"
  add_foreign_key "shared_folders", "folders"
  add_foreign_key "shared_folders", "shared_lists"
  add_foreign_key "shared_lists", "users"
end
