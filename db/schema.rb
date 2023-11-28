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

ActiveRecord::Schema[7.0].define(version: 2023_11_27_024003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "arask_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "job"
    t.datetime "execute_at"
    t.string "interval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["execute_at"], name: "index_arask_jobs_on_execute_at"
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

  add_foreign_key "orders", "customers"
end
