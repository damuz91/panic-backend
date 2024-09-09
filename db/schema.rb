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

ActiveRecord::Schema[7.1].define(version: 2024_09_05_213726) do
  create_table "messages", force: :cascade do |t|
    t.integer "request_id", null: false
    t.string "message"
    t.string "destination"
    t.string "message_type"
    t.string "status"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["request_id"], name: "index_messages_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "os"
    t.string "request_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "store_user_id"
    t.string "name"
    t.boolean "is_premium", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "messages", "requests"
  add_foreign_key "requests", "users"
end
