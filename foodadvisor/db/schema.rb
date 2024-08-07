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

ActiveRecord::Schema.define(version: 2024_07_17_144225) do

  create_table "admins", force: :cascade do |t|
    t.integer "utente_id", null: false
    t.string "nome"
    t.string "cognome"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["utente_id"], name: "index_admins_on_utente_id"
  end

  create_table "answers", force: :cascade do |t|
    t.integer "recensione_id", null: false
    t.integer "ristoratore_id", null: false
    t.string "risposta"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recensione_id"], name: "index_answers_on_recensione_id"
    t.index ["ristoratore_id"], name: "index_answers_on_ristoratore_id"
  end

  create_table "assign_stars", force: :cascade do |t|
    t.integer "cliente_id"
    t.integer "recensione_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cliente_id"], name: "index_assign_stars_on_cliente_id"
    t.index ["recensione_id"], name: "index_assign_stars_on_recensione_id"
  end

  create_table "chooses", force: :cascade do |t|
    t.integer "ristoratore_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ristoratore_id"], name: "index_chooses_on_ristoratore_id"
    t.index ["tag_id"], name: "index_chooses_on_tag_id"
  end

  create_table "clientes", force: :cascade do |t|
    t.integer "utente_id", null: false
    t.string "foto"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["utente_id"], name: "index_clientes_on_utente_id"
  end

  create_table "competiziones", force: :cascade do |t|
    t.string "nome"
    t.string "descrizione"
    t.string "locandina"
    t.string "requisiti"
    t.string "premio"
    t.integer "quantitareq", default: 0
    t.datetime "data_inizio"
    t.datetime "data_fine"
    t.integer "ristoratore_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ristoratore_id"], name: "index_competiziones_on_ristoratore_id"
  end

  create_table "criticos", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "certificato"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_criticos_on_user_id"
  end

  create_table "dipendentes", force: :cascade do |t|
    t.string "nome"
    t.string "cognome"
    t.string "foto"
    t.string "ruolo"
    t.date "assunzione"
    t.integer "ristoratore_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ristoratore_id"], name: "index_dipendentes_on_ristoratore_id"
  end

  create_table "eventos", force: :cascade do |t|
    t.string "nome", null: false
    t.date "data", null: false
    t.string "luogo", null: false
    t.string "descrizione"
    t.string "locandina"
    t.integer "ristoratore_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ristoratore_id"], name: "index_eventos_on_ristoratore_id"
  end

  create_table "fav_recipes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "recipe_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipe_id"], name: "index_fav_recipes_on_recipe_id"
    t.index ["user_id"], name: "index_fav_recipes_on_user_id"
  end

  create_table "fav_ristorantis", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "ristoratore_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ristoratore_id"], name: "index_fav_ristorantis_on_ristoratore_id"
    t.index ["user_id"], name: "index_fav_ristorantis_on_user_id"
  end

  create_table "menus", force: :cascade do |t|
    t.integer "ristoratore_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ristoratore_id"], name: "index_menus_on_ristoratore_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "cliente_id"
    t.string "email"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cliente_id"], name: "index_notifications_on_cliente_id"
  end

  create_table "piattos", force: :cascade do |t|
    t.integer "menu_id", null: false
    t.string "nome"
    t.float "prezzo"
    t.string "foto"
    t.string "ingredienti"
    t.string "categoria"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["menu_id"], name: "index_piattos_on_menu_id"
  end

  create_table "premis", force: :cascade do |t|
    t.string "nomecompetizione"
    t.string "nome"
    t.date "data_inizio"
    t.date "data_fine"
    t.integer "user_id", null: false
    t.integer "ristoratore_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ristoratore_id"], name: "index_premis_on_ristoratore_id"
    t.index ["user_id"], name: "index_premis_on_user_id"
  end

  create_table "prenotaziones", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "ristoratore_id", null: false
    t.integer "numero_persone", null: false
    t.date "data", null: false
    t.time "orario", null: false
    t.boolean "valida", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ristoratore_id"], name: "index_prenotaziones_on_ristoratore_id"
    t.index ["user_id"], name: "index_prenotaziones_on_user_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "text"
    t.boolean "stato", default: false, null: false
    t.integer "cliente_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cliente_id"], name: "index_problems_on_cliente_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.date "data_inizio"
    t.date "data_fine"
    t.string "condizioni"
    t.string "tipo"
    t.integer "ristoratore_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ristoratore_id"], name: "index_promotions_on_ristoratore_id"
  end

  create_table "recensiones", force: :cascade do |t|
    t.integer "cliente_id", null: false
    t.integer "ristoratore_id", null: false
    t.string "commento"
    t.boolean "pinnata", default: false
    t.integer "stelle"
    t.integer "like", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cliente_id"], name: "index_recensiones_on_cliente_id"
    t.index ["ristoratore_id"], name: "index_recensiones_on_ristoratore_id"
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
    t.index ["ristoratore_id"], name: "index_recipes_on_ristoratore_id"
  end

  create_table "ristoratores", force: :cascade do |t|
    t.integer "cliente_id", null: false
    t.string "piva"
    t.boolean "asporto"
    t.string "nomeristorante"
    t.string "indirizzo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cliente_id"], name: "index_ristoratores_on_cliente_id"
  end

  create_table "segnalaziones", force: :cascade do |t|
    t.integer "recensione_id"
    t.integer "cliente_id", null: false
    t.integer "cliente_segnalato_id", null: false
    t.string "motivo"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cliente_id"], name: "index_segnalaziones_on_cliente_id"
    t.index ["cliente_segnalato_id"], name: "index_segnalaziones_on_cliente_segnalato_id"
    t.index ["recensione_id"], name: "index_segnalaziones_on_recensione_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "font", default: "Arial"
    t.string "font_size", default: "medium"
    t.string "theme", default: "day"
    t.integer "utente_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["utente_id"], name: "index_settings_on_utente_id"
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
    t.integer "punti_competizione", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["competizione_id"], name: "index_user_competitions_on_competizione_id"
    t.index ["user_id"], name: "index_user_competitions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "cliente_id", null: false
    t.string "username"
    t.string "nome"
    t.string "cognome"
    t.date "datanascita"
    t.integer "punti", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cliente_id"], name: "index_users_on_cliente_id"
  end

  create_table "utentes", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "telefono"
    t.string "tmp_password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "facebook_id"
    t.string "name"
    t.string "remember_digest"
    t.string "uid"
    t.string "provider"
  end

  add_foreign_key "admins", "utentes"
  add_foreign_key "answers", "recensiones"
  add_foreign_key "answers", "ristoratores"
  add_foreign_key "assign_stars", "clientes"
  add_foreign_key "assign_stars", "recensiones"
  add_foreign_key "chooses", "ristoratores", on_delete: :cascade
  add_foreign_key "chooses", "tags"
  add_foreign_key "clientes", "utentes"
  add_foreign_key "competiziones", "ristoratores"
  add_foreign_key "criticos", "users"
  add_foreign_key "dipendentes", "ristoratores"
  add_foreign_key "eventos", "ristoratores"
  add_foreign_key "fav_recipes", "recipes"
  add_foreign_key "fav_recipes", "users"
  add_foreign_key "fav_ristorantis", "ristoratores"
  add_foreign_key "fav_ristorantis", "users"
  add_foreign_key "menus", "ristoratores"
  add_foreign_key "notifications", "clientes"
  add_foreign_key "piattos", "menus"
  add_foreign_key "premis", "ristoratores"
  add_foreign_key "premis", "users"
  add_foreign_key "prenotaziones", "ristoratores"
  add_foreign_key "prenotaziones", "users"
  add_foreign_key "problems", "clientes"
  add_foreign_key "promotions", "ristoratores"
  add_foreign_key "recensiones", "clientes"
  add_foreign_key "recensiones", "ristoratores"
  add_foreign_key "ristoratores", "clientes"
  add_foreign_key "segnalaziones", "clientes"
  add_foreign_key "segnalaziones", "clientes", column: "cliente_segnalato_id"
  add_foreign_key "segnalaziones", "recensiones"
  add_foreign_key "settings", "utentes"
  add_foreign_key "user_competitions", "competiziones", on_delete: :cascade
  add_foreign_key "user_competitions", "users"
  add_foreign_key "users", "clientes"
end
