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

ActiveRecord::Schema.define(version: 2024_06_25_135004) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "problems", force: :cascade do |t|
    t.integer "id_utente"
    t.string "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id_utente"], name: "index_problems_on_id_utente"
  end

  create_table "ristoratoris", force: :cascade do |t|
    t.string "restaurant_name", null: false
    t.integer "piva", limit: 8, null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "password_digest", null: false
    t.binary "foto"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role"
  end

  create_table "settings", force: :cascade do |t|
    t.string "font"
    t.string "font_size"
    t.string "theme"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  add_foreign_key "competiziones", "users", column: "owner"
  add_foreign_key "dishes", "categories"
  add_foreign_key "problems", "users", column: "id_utente"
end
