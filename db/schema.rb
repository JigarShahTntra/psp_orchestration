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

ActiveRecord::Schema[7.2].define(version: 2025_09_02_101709) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "payments", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.string "currency", null: false
    t.string "status", default: "pending", null: false
    t.integer "psp_id"
    t.string "external_id"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_payments_on_external_id"
    t.index ["psp_id"], name: "index_payments_on_psp_id"
  end

  create_table "psp_mappings", force: :cascade do |t|
    t.bigint "psp_id", null: false
    t.jsonb "request_templates", default: {}
    t.jsonb "response_templates", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["psp_id"], name: "index_psp_mappings_on_psp_id"
  end

  create_table "psps", force: :cascade do |t|
    t.string "name", null: false
    t.string "psp_type", null: false
    t.jsonb "endpoints", default: {}
    t.jsonb "auth", default: {}
    t.jsonb "credentials", default: {}
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_psps_on_name", unique: true
  end

  create_table "routing_rules", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "conditions", default: {}
    t.bigint "psp_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_routing_rules_on_active"
    t.index ["psp_id"], name: "index_routing_rules_on_psp_id"
  end

  add_foreign_key "psp_mappings", "psps"
  add_foreign_key "routing_rules", "psps"
end
