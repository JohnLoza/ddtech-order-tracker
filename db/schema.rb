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

ActiveRecord::Schema.define(version: 2021_02_05_151914) do

  create_table "devolutions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "rma"
    t.string "client_name"
    t.string "email"
    t.string "telephone"
    t.string "client_type"
    t.string "order_id"
    t.string "products"
    t.string "description"
    t.string "comments"
    t.string "street"
    t.string "colony"
    t.string "zc"
    t.string "city"
    t.string "state"
    t.string "actions_taken"
    t.string "guide_id"
    t.string "parcel"
    t.string "voucher_folio"
    t.decimal "voucher_amount", precision: 8, scale: 2
    t.boolean "free_guide", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_devolutions_on_email"
    t.index ["order_id"], name: "index_devolutions_on_order_id"
    t.index ["rma"], name: "index_devolutions_on_rma", unique: true
    t.index ["user_id"], name: "index_devolutions_on_user_id"
  end

  create_table "movements", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.string "description"
    t.string "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_movements_on_order_id"
    t.index ["user_id"], name: "index_movements_on_user_id"
  end

  create_table "notes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_notes_on_order_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "order_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "tag_id"
    t.index ["order_id"], name: "index_order_tags_on_order_id"
    t.index ["tag_id"], name: "index_order_tags_on_tag_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.string "ddtech_key"
    t.string "client_email"
    t.string "status"
    t.string "parcel"
    t.string "guide"
    t.boolean "holding", default: false
    t.boolean "assemble", default: false
    t.boolean "multiple_packages", default: false
    t.boolean "urgent", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_email"], name: "index_orders_on_client_email"
    t.index ["ddtech_key"], name: "index_orders_on_ddtech_key", unique: true
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "origin_states", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "estimated_shipment_days"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shipment_product_destinations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "shipment_product_id", null: false
    t.string "destination"
    t.integer "units"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipment_product_id"], name: "index_shipment_product_destinations_on_shipment_product_id"
  end

  create_table "shipment_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "shipment_id", null: false
    t.string "ddtech_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shipment_id"], name: "index_shipment_products_on_shipment_id"
  end

  create_table "shipments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "hash_id"
    t.bigint "origin_state_id", null: false
    t.bigint "supplier_id", null: false
    t.datetime "estimated_arrival"
    t.string "comments"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["origin_state_id"], name: "index_shipments_on_origin_state_id"
    t.index ["supplier_id"], name: "index_shipments_on_supplier_id"
  end

  create_table "suppliers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "css_class"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "role"
    t.string "password_digest"
    t.string "recover_password_digest"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "shipment_product_destinations", "shipment_products"
  add_foreign_key "shipment_products", "shipments"
  add_foreign_key "shipments", "origin_states"
  add_foreign_key "shipments", "suppliers"
end
