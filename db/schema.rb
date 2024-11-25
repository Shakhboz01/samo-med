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

ActiveRecord::Schema[7.0].define(version: 2024_11_25_124822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "analysis_results", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "comment"
    t.bigint "buyer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "uniq_id"
    t.index ["buyer_id"], name: "index_analysis_results_on_buyer_id"
    t.index ["user_id"], name: "index_analysis_results_on_user_id"
  end

  create_table "bonus_users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "buyers", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "comment"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
    t.boolean "is_worker", default: false
    t.string "jshr"
    t.date "birthday"
    t.integer "gender", default: 0
    t.boolean "is_room_member", default: false
    t.string "job"
    t.string "address"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.string "hex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "combination_of_local_products", force: :cascade do |t|
    t.string "comment"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "currency_conversions", force: :cascade do |t|
    t.decimal "rate", precision: 9, scale: 2
    t.boolean "to_uzs", default: true
    t.bigint "user_id", null: false
    t.decimal "price_in_uzs", precision: 18, scale: 2
    t.decimal "price_in_usd", precision: 18, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_currency_conversions_on_user_id"
  end

  create_table "currency_rates", force: :cascade do |t|
    t.decimal "rate", precision: 12, scale: 2
    t.datetime "finished_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "daily_transaction_reports", force: :cascade do |t|
    t.decimal "income_in_usd", precision: 18, scale: 2
    t.decimal "income_in_uzs", precision: 18, scale: 2
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_daily_transaction_reports_on_user_id"
  end

  create_table "debt_operations", force: :cascade do |t|
    t.boolean "debt_in_usd", default: true
    t.integer "status", default: 0
    t.decimal "price", precision: 18, scale: 2
    t.bigint "user_id", null: false
    t.bigint "debt_user_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debt_user_id"], name: "index_debt_operations_on_debt_user_id"
    t.index ["user_id"], name: "index_debt_operations_on_user_id"
  end

  create_table "debt_users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delivery_from_counterparties", force: :cascade do |t|
    t.decimal "total_price", precision: 16, scale: 2, default: "0.0"
    t.decimal "total_paid"
    t.integer "payment_type", default: 0
    t.string "comment"
    t.integer "status", default: 0
    t.bigint "provider_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "price_in_usd", default: false
    t.boolean "with_image", default: false
    t.bigint "product_category_id"
    t.boolean "enable_to_send_sms", default: true
    t.index ["product_category_id"], name: "index_delivery_from_counterparties_on_product_category_id"
    t.index ["provider_id"], name: "index_delivery_from_counterparties_on_provider_id"
    t.index ["user_id"], name: "index_delivery_from_counterparties_on_user_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.bigint "sale_id", null: false
    t.boolean "verified", default: false
    t.boolean "price_in_usd", default: false
    t.decimal "price", precision: 15, scale: 2
    t.string "comment"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_id"], name: "index_discounts_on_sale_id"
    t.index ["user_id"], name: "index_discounts_on_user_id"
  end

  create_table "expenditures", force: :cascade do |t|
    t.bigint "combination_of_local_product_id"
    t.decimal "price", default: "0.0"
    t.decimal "total_paid"
    t.integer "expenditure_type"
    t.integer "payment_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "delivery_from_counterparty_id"
    t.boolean "price_in_usd", default: false
    t.string "sale_ids"
    t.boolean "with_image", default: false
    t.bigint "user_id"
    t.string "comment"
    t.index ["combination_of_local_product_id"], name: "index_expenditures_on_combination_of_local_product_id"
    t.index ["delivery_from_counterparty_id"], name: "index_expenditures_on_delivery_from_counterparty_id"
    t.index ["user_id"], name: "index_expenditures_on_user_id"
  end

  create_table "local_services", force: :cascade do |t|
    t.decimal "price", precision: 16, scale: 2
    t.string "comment"
    t.bigint "sale_from_local_service_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_from_local_service_id"], name: "index_local_services_on_sale_from_local_service_id"
    t.index ["user_id"], name: "index_local_services_on_user_id"
  end

  create_table "owners_operations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "operation_type", default: 0
    t.boolean "price_in_usd", default: true
    t.decimal "price", precision: 19, scale: 2
    t.bigint "operator_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_owners_operations_on_user_id"
  end

  create_table "pack_usages", force: :cascade do |t|
    t.bigint "pack_id", null: false
    t.integer "list_of_pack_id"
    t.decimal "amount", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pack_id"], name: "index_pack_usages_on_pack_id"
  end

  create_table "packs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "barcode"
    t.integer "initial_remaining", default: 0
    t.decimal "sell_price", precision: 17, scale: 2
    t.decimal "buy_price", precision: 17, scale: 2
    t.boolean "price_in_usd", default: false
    t.boolean "active", default: true
    t.bigint "product_category_id"
    t.integer "unit"
    t.index ["product_category_id"], name: "index_packs_on_product_category_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "printer_ips", force: :cascade do |t|
    t.string "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
  end

  create_table "product_entries", force: :cascade do |t|
    t.decimal "buy_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "sell_price", precision: 10, scale: 2, default: "0.0"
    t.boolean "paid_in_usd", default: false
    t.decimal "service_price", precision: 10, scale: 2
    t.decimal "amount", precision: 18, scale: 2, default: "0.0"
    t.decimal "amount_sold", precision: 18, scale: 2, default: "0.0"
    t.string "comment"
    t.integer "payment_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "delivery_from_counterparty_id"
    t.bigint "combination_of_local_product_id"
    t.boolean "local_entry", default: false
    t.boolean "return", default: false
    t.decimal "price_in_percentage", precision: 5, scale: 2
    t.bigint "pack_id", null: false
    t.bigint "user_id"
    t.index ["combination_of_local_product_id"], name: "index_product_entries_on_combination_of_local_product_id"
    t.index ["delivery_from_counterparty_id"], name: "index_product_entries_on_delivery_from_counterparty_id"
    t.index ["pack_id"], name: "index_product_entries_on_pack_id"
    t.index ["user_id"], name: "index_product_entries_on_user_id"
  end

  create_table "product_remaining_inequalities", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "amount"
    t.decimal "previous_amount"
    t.string "reason"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_remaining_inequalities_on_product_id"
    t.index ["user_id"], name: "index_product_remaining_inequalities_on_user_id"
  end

  create_table "product_sells", force: :cascade do |t|
    t.bigint "combination_of_local_product_id"
    t.bigint "product_id"
    t.decimal "buy_price", precision: 16, scale: 2, default: "0.0"
    t.decimal "sell_price", precision: 16, scale: 2, default: "0.0"
    t.decimal "total_profit", default: "0.0"
    t.jsonb "price_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount", precision: 15, scale: 2, default: "0.0"
    t.jsonb "average_prices"
    t.bigint "sale_from_local_service_id"
    t.bigint "sale_id"
    t.bigint "sale_from_service_id"
    t.boolean "price_in_usd", default: false
    t.bigint "pack_id"
    t.decimal "sell_price_in_uzs", precision: 17, scale: 2
    t.boolean "sell_by_piece", default: false
    t.boolean "danger_zone", default: false
    t.index ["combination_of_local_product_id"], name: "index_product_sells_on_combination_of_local_product_id"
    t.index ["pack_id"], name: "index_product_sells_on_pack_id"
    t.index ["product_id"], name: "index_product_sells_on_product_id"
    t.index ["sale_from_local_service_id"], name: "index_product_sells_on_sale_from_local_service_id"
    t.index ["sale_from_service_id"], name: "index_product_sells_on_sale_from_service_id"
    t.index ["sale_id"], name: "index_product_sells_on_sale_id"
  end

  create_table "product_size_colors", force: :cascade do |t|
    t.bigint "color_id", null: false
    t.bigint "size_id", null: false
    t.integer "amount", default: 1
    t.bigint "pack_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["color_id"], name: "index_product_size_colors_on_color_id"
    t.index ["pack_id"], name: "index_product_size_colors_on_pack_id"
    t.index ["size_id"], name: "index_product_size_colors_on_size_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.boolean "local", default: false
    t.boolean "active", default: true
    t.decimal "sell_price", precision: 14, scale: 2, default: "0.0"
    t.decimal "buy_price", precision: 14, scale: 2, default: "0.0"
    t.decimal "initial_remaining", precision: 15, scale: 2, default: "0.0"
    t.integer "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "price_in_usd", default: false
    t.string "code"
    t.bigint "color_id"
    t.bigint "size_id"
    t.string "barcode"
    t.bigint "pack_id"
    t.index ["color_id"], name: "index_products_on_color_id"
    t.index ["pack_id"], name: "index_products_on_pack_id"
    t.index ["size_id"], name: "index_products_on_size_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "phone_number"
    t.string "comment"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 0
  end

  create_table "queue_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_queue_histories_on_user_id"
  end

  create_table "room_members", force: :cascade do |t|
    t.boolean "active_member", default: true
    t.string "comment"
    t.bigint "buyer_id", null: false
    t.datetime "end_time"
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_room_members_on_buyer_id"
    t.index ["room_id"], name: "index_room_members_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "capacity"
    t.integer "active_members", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 12, scale: 2
  end

  create_table "salaries", force: :cascade do |t|
    t.boolean "prepayment"
    t.date "month", default: "2024-09-02"
    t.bigint "team_id"
    t.bigint "user_id"
    t.decimal "price", precision: 10, scale: 2
    t.integer "payment_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_salaries_on_team_id"
    t.index ["user_id"], name: "index_salaries_on_user_id"
  end

  create_table "sale_from_local_services", force: :cascade do |t|
    t.decimal "total_price", precision: 18, scale: 2, default: "0.0"
    t.decimal "total_paid", precision: 18, scale: 2
    t.string "coment"
    t.bigint "buyer_id", null: false
    t.integer "payment_type", default: 0
    t.integer "status", default: 0
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_sale_from_local_services_on_buyer_id"
    t.index ["user_id"], name: "index_sale_from_local_services_on_user_id"
  end

  create_table "sale_from_services", force: :cascade do |t|
    t.decimal "total_paid", precision: 17, scale: 2, default: "0.0"
    t.integer "payment_type", default: 0
    t.bigint "buyer_id", null: false
    t.decimal "total_price", precision: 17, scale: 2, default: "0.0"
    t.string "comment"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_sale_from_services_on_buyer_id"
    t.index ["user_id"], name: "index_sale_from_services_on_user_id"
  end

  create_table "sales", force: :cascade do |t|
    t.decimal "total_paid", precision: 17, scale: 2, default: "0.0"
    t.integer "payment_type", default: 0
    t.bigint "buyer_id", null: false
    t.decimal "total_price", precision: 17, scale: 2, default: "0.0"
    t.string "comment"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "price_in_usd", default: false
    t.boolean "enable_to_send_sms", default: true
    t.decimal "total_worker_price", precision: 10, scale: 2
    t.bigint "bonus_user_id"
    t.index ["bonus_user_id"], name: "index_sales_on_bonus_user_id"
    t.index ["buyer_id"], name: "index_sales_on_buyer_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.integer "unit"
    t.decimal "price", precision: 15, scale: 2, default: "0.0"
    t.boolean "active", default: true
    t.bigint "user_id", null: false
    t.integer "team_fee_in_percent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "storages", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_services", force: :cascade do |t|
    t.bigint "sale_from_service_id", null: false
    t.bigint "team_id", null: false
    t.decimal "total_price", precision: 17, scale: 2, default: "0.0"
    t.integer "team_fee", default: 30
    t.decimal "team_portion", precision: 17, scale: 2, default: "0.0"
    t.decimal "company_portion", precision: 17, scale: 2, default: "0.0"
    t.bigint "user_id"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sale_from_service_id"], name: "index_team_services_on_sale_from_service_id"
    t.index ["team_id"], name: "index_team_services_on_team_id"
    t.index ["user_id"], name: "index_team_services_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.bigint "sale_id"
    t.bigint "sale_from_service_id"
    t.bigint "sale_from_local_service_id"
    t.bigint "delivery_from_counterparty_id"
    t.bigint "expenditure_id"
    t.decimal "price", precision: 17, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "price_in_usd", default: false
    t.bigint "user_id"
    t.boolean "first_record", default: false
    t.integer "payment_type", default: 0
    t.index ["delivery_from_counterparty_id"], name: "index_transaction_histories_on_delivery_from_counterparty_id"
    t.index ["expenditure_id"], name: "index_transaction_histories_on_expenditure_id"
    t.index ["sale_from_local_service_id"], name: "index_transaction_histories_on_sale_from_local_service_id"
    t.index ["sale_from_service_id"], name: "index_transaction_histories_on_sale_from_service_id"
    t.index ["sale_id"], name: "index_transaction_histories_on_sale_id"
    t.index ["user_id"], name: "index_transaction_histories_on_user_id"
  end

  create_table "treatments", force: :cascade do |t|
    t.bigint "buyer_id", null: false
    t.bigint "user_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "bosh_ogriq", default: false
    t.boolean "qon_bosimi_kotarilishi", default: false
    t.boolean "holsizlik", default: false
    t.boolean "bel_va_oyoq_ogriqi", default: false
    t.boolean "gejga_tolishi", default: false
    t.boolean "teri_kasalliklari", default: false
    t.boolean "koz_kasalliklari", default: false
    t.boolean "jkt_kasalliklari", default: false
    t.boolean "boshqa_shikoyatlar", default: false
    t.boolean "tish_gijirlashi", default: false
    t.boolean "jirrakilik", default: false
    t.boolean "orqa_qichishishi", default: false
    t.boolean "toshma_va_doglar", default: false
    t.boolean "ishtaxasizlik", default: false
    t.boolean "boy_osmaslik", default: false
    t.boolean "oyoq_ogrigi", default: false
    t.boolean "siyib_qoyish", default: false
    t.boolean "gepatit_a", default: false
    t.boolean "gepatit_b", default: false
    t.boolean "gepatit_c", default: false
    t.boolean "gepatit_d", default: false
    t.boolean "gepatit_e", default: false
    t.index ["buyer_id"], name: "index_treatments_on_buyer_id"
    t.index ["user_id"], name: "index_treatments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "role", default: 2
    t.string "name"
    t.boolean "active", default: true
    t.boolean "allowed_to_use", default: true
    t.integer "daily_payment", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "telegram_chat_id"
    t.string "string"
    t.string "context"
    t.integer "buyer_context"
    t.string "phone_number"
    t.string "address"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "analysis_results", "buyers"
  add_foreign_key "analysis_results", "users"
  add_foreign_key "currency_conversions", "users"
  add_foreign_key "daily_transaction_reports", "users"
  add_foreign_key "debt_operations", "debt_users"
  add_foreign_key "debt_operations", "users"
  add_foreign_key "delivery_from_counterparties", "product_categories"
  add_foreign_key "delivery_from_counterparties", "providers"
  add_foreign_key "delivery_from_counterparties", "users"
  add_foreign_key "discounts", "sales"
  add_foreign_key "discounts", "users"
  add_foreign_key "expenditures", "combination_of_local_products"
  add_foreign_key "expenditures", "delivery_from_counterparties"
  add_foreign_key "expenditures", "users"
  add_foreign_key "local_services", "sale_from_local_services"
  add_foreign_key "local_services", "users"
  add_foreign_key "owners_operations", "users"
  add_foreign_key "pack_usages", "packs"
  add_foreign_key "packs", "product_categories"
  add_foreign_key "participations", "users"
  add_foreign_key "product_entries", "combination_of_local_products"
  add_foreign_key "product_entries", "delivery_from_counterparties"
  add_foreign_key "product_entries", "packs"
  add_foreign_key "product_entries", "users"
  add_foreign_key "product_remaining_inequalities", "products"
  add_foreign_key "product_remaining_inequalities", "users"
  add_foreign_key "product_sells", "combination_of_local_products"
  add_foreign_key "product_sells", "products"
  add_foreign_key "product_sells", "sale_from_local_services"
  add_foreign_key "product_sells", "sale_from_services"
  add_foreign_key "product_sells", "sales"
  add_foreign_key "product_size_colors", "colors"
  add_foreign_key "product_size_colors", "packs"
  add_foreign_key "product_size_colors", "sizes"
  add_foreign_key "products", "colors"
  add_foreign_key "products", "sizes"
  add_foreign_key "queue_histories", "users"
  add_foreign_key "room_members", "buyers"
  add_foreign_key "room_members", "rooms"
  add_foreign_key "salaries", "teams"
  add_foreign_key "salaries", "users"
  add_foreign_key "sale_from_local_services", "buyers"
  add_foreign_key "sale_from_local_services", "users"
  add_foreign_key "sale_from_services", "buyers"
  add_foreign_key "sale_from_services", "users"
  add_foreign_key "sales", "bonus_users"
  add_foreign_key "sales", "buyers"
  add_foreign_key "sales", "users"
  add_foreign_key "services", "users"
  add_foreign_key "team_services", "sale_from_services"
  add_foreign_key "team_services", "teams"
  add_foreign_key "team_services", "users"
  add_foreign_key "transaction_histories", "delivery_from_counterparties"
  add_foreign_key "transaction_histories", "expenditures"
  add_foreign_key "transaction_histories", "sale_from_local_services"
  add_foreign_key "transaction_histories", "sale_from_services"
  add_foreign_key "transaction_histories", "sales"
  add_foreign_key "transaction_histories", "users"
  add_foreign_key "treatments", "buyers"
  add_foreign_key "treatments", "users"
end
