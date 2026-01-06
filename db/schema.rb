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

ActiveRecord::Schema[8.1].define(version: 2025_01_06_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "comments", force: :cascade do |t|
    t.boolean "archived", default: false, null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.bigint "issue_id", null: false
    t.tsvector "search_vector"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["archived"], name: "index_comments_on_archived"
    t.index ["issue_id", "created_at", "id"], name: "ix_comments_issue_created"
    t.index ["issue_id", "user_id", "created_at", "id"], name: "ix_comments_issue_user_created"
    t.index ["issue_id"], name: "index_comments_on_issue_id"
    t.index ["search_vector"], name: "index_comments_on_search_vector", using: :gin
    t.index ["user_id", "created_at", "id"], name: "ix_comments_user_created"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "document_activities", force: :cascade do |t|
    t.string "activity_type", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "document_id", null: false
    t.integer "performed_by_id"
    t.datetime "updated_at", null: false
    t.index ["activity_type"], name: "index_document_activities_on_activity_type"
    t.index ["document_id"], name: "index_document_activities_on_document_id"
    t.index ["performed_by_id"], name: "index_document_activities_on_performed_by_id"
  end

  create_table "document_comments", force: :cascade do |t|
    t.integer "author_id"
    t.text "comment", null: false
    t.datetime "created_at", null: false
    t.bigint "document_id", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_document_comments_on_author_id"
    t.index ["document_id"], name: "index_document_comments_on_document_id"
  end

  create_table "document_versions", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "document_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "version_number", null: false
    t.index ["document_id", "version_number"], name: "index_document_versions_on_document_id_and_version_number", unique: true
    t.index ["document_id"], name: "index_document_versions_on_document_id"
  end

  create_table "documents", force: :cascade do |t|
    t.integer "author_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.string "status", default: "draft"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_documents_on_author_id"
    t.index ["status"], name: "index_documents_on_status"
  end

  create_table "issues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "priority", null: false
    t.string "status", null: false
    t.text "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["status"], name: "index_issues_on_status"
    t.index ["user_id"], name: "index_issues_on_user_id"
    t.check_constraint "priority >= 1 AND priority <= 5", name: "check_priority"
    t.check_constraint "status::text = ANY (ARRAY['open'::character varying, 'closed'::character varying]::text[])", name: "check_status"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "handle", null: false
    t.datetime "updated_at", null: false
    t.index ["handle"], name: "index_users_on_handle", unique: true
  end

  add_foreign_key "comments", "issues"
  add_foreign_key "comments", "users"
  add_foreign_key "document_activities", "documents"
  add_foreign_key "document_comments", "documents"
  add_foreign_key "document_versions", "documents"
  add_foreign_key "issues", "users"
end
