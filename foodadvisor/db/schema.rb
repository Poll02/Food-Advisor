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

ActiveRecord::Schema.define(version: 2024_07_01_225720) do

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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chooses", id: false, force: :cascade do |t|
    t.integer "ristoratori_id", null: false
    t.integer "tag_id", null: false
    t.index ["ristoratori_id", "tag_id"], name: "index_chooses_on_ristoratori_id_and_tag_id", unique: true
    t.index ["ristoratori_id"], name: "index_chooses_on_ristoratori_id"
    t.index ["tag_id"], name: "index_chooses_on_tag_id"
  end

  create_table "competiziones", force: :cascade do |t|
    t.string "nome"
    t.string "descrizione"
    t.string "locandina"
    t.string "requisiti"
    t.string "premio"
    t.string "tag"
    t.integer "owner", null: false
    t.datetime "data_inizio"
    t.datetime "data_fine"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dishes", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.text "ingredients"
    t.integer "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_dishes_on_category_id"
  end

  create_table "eventos", force: :cascade do |t|
    t.integer "owner", null: false
    t.string "nome", null: false
    t.date "data", null: false
    t.string "luogo", null: false
    t.string "descrizione"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "locandina"
  end

  create_table "problems", force: :cascade do |t|
    t.integer "id_utente"
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id_utente"], name: "index_problems_on_id_utente"
  end

  create_table "promotions", force: :cascade do |t|
    t.date "data_inizio"
    t.date "data_fine"
    t.string "condizioni"
    t.string "tipo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "ristoratore_id"
    t.index ["ristoratore_id"], name: "index_promotions_on_ristoratore_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "name", null: false
    t.string "difficulty", null: false
    t.string "ingredients", null: false
    t.string "procedure", null: false
    t.string "photo"
    t.integer "ristoratore_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ristoratoris", force: :cascade do |t|
    t.string "restaurant_name", null: false
    t.integer "piva", limit: 8, null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role"
    t.string "profile_picture_url"
    t.string "photo"
    t.string "indirizzo"
  end

  create_table "settings", force: :cascade do |t|
    t.string "font"
    t.string "font_size"
    t.string "theme"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "nome"
    t.string "categoria"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_competitions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "competizione_id", null: false
    t.integer "punti", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["competizione_id"], name: "index_user_competitions_on_competizione_id"
    t.index ["user_id"], name: "index_user_competitions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.date "birth"
    t.string "email"
    t.string "phone"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role"
    t.string "restaurant_name"
    t.string "partita_iva"
  end

  add_foreign_key "chooses", "ristoratoris", on_delete: :cascade
  add_foreign_key "chooses", "tags", on_delete: :cascade
  add_foreign_key "competiziones", "users", column: "owner"
  add_foreign_key "dishes", "categories", on_delete: :cascade
  add_foreign_key "eventos", "ristoratoris", column: "owner", on_delete: :cascade
  add_foreign_key "problems", "users", column: "id_utente", on_delete: :cascade
  add_foreign_key "promotions", "ristoratoris", column: "ristoratore_id", on_delete: :cascade
  add_foreign_key "recipes", "ristoratoris", column: "ristoratore_id"
  add_foreign_key "user_competitions", "competiziones"
  add_foreign_key "user_competitions", "users"
end
