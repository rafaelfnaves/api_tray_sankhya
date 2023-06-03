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

ActiveRecord::Schema[7.0].define(version: 2023_05_16_165706) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "timescaledb"

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "type"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "api_order_jalls", force: :cascade do |t|
    t.string "order_id"
    t.string "invoice_number"
    t.integer "invoice_id"
    t.float "value_order"
    t.integer "qtde_order"
    t.string "invoice_key"
    t.text "body_jall"
    t.string "file_jall"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body_tracking"
    t.string "response_code_tracking"
    t.text "response_tracking"
  end

  create_table "cities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.integer "codcid"
    t.integer "coduf"
    t.integer "codmunfis"
    t.integer "codmunsiafi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cnpj"
    t.string "id_tray"
    t.string "name"
    t.string "rg"
    t.string "cpf"
    t.string "phone"
    t.string "cellphone"
    t.string "email"
    t.string "token"
    t.string "company_name"
    t.string "state_inscription"
    t.string "discount"
    t.string "blocked_tray"
    t.string "profile_customer_id"
    t.string "address"
    t.string "zip_code"
    t.string "number_address"
    t.string "complement"
    t.string "neighborhood"
    t.string "city"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code_par_snk"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "handlings", force: :cascade do |t|
    t.string "tracking_code"
    t.string "card_number"
    t.string "code"
    t.string "card_description"
    t.string "name"
    t.string "cpf"
    t.bigint "ticket_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.string "file_name"
    t.boolean "validated", default: false
    t.string "plan"
    t.string "state"
    t.string "zipcode"
    t.string "city"
    t.boolean "canceled", default: false
    t.index ["ticket_id"], name: "index_handlings_on_ticket_id"
  end

  create_table "imports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "upload_ticket"
    t.string "upload_handling"
  end

  create_table "orders", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "invoice"
    t.string "date"
    t.string "code_type_operation"
    t.string "type_deal"
    t.string "code_salesman"
    t.string "code_company"
    t.string "type_move"
    t.uuid "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "total"
    t.date "payment_date"
    t.string "product_id_tray"
    t.string "id_tray"
    t.string "nu_nota"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "sku"
    t.string "active"
    t.float "price"
    t.float "cost"
    t.string "ncm"
    t.string "name"
    t.integer "stock"
    t.string "brand"
    t.integer "weight"
    t.integer "height"
    t.integer "width"
    t.integer "length"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "id_tray"
    t.string "category"
    t.string "volume"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "addressee"
    t.string "cpf"
    t.string "zipcode"
    t.string "address"
    t.string "neighborhood"
    t.string "complement"
    t.string "city"
    t.string "state"
    t.string "plan"
    t.string "tracking_code"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.string "file_name"
    t.string "hawb_id"
    t.string "ar_correios"
    t.boolean "consult_api", default: false
    t.text "cards"
    t.string "number"
    t.integer "imported_jall", default: 0
    t.string "file_jall"
    t.boolean "canceled", default: false
    t.integer "qtd_cards"
  end

  create_table "user_auths", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind"
    t.integer "status"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "handlings", "tickets"
  add_foreign_key "orders", "customers"
end
