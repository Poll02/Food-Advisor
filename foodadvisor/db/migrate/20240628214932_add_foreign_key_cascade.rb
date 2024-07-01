class AddForeignKeyCascade < ActiveRecord::Migration[6.1]
  def change
    # Rimuovere le chiavi esterne attuali
    remove_foreign_key :chooses, :ristoratoris
    remove_foreign_key :chooses, :tags
    remove_foreign_key :dishes, :categories
    remove_foreign_key :eventos, :ristoratoris, column: :owner
    remove_foreign_key :problems, :users, column: :id_utente
    remove_foreign_key :promotions, :ristoratoris, column: :ristoratore_id

    # Aggiungere le chiavi esterne con ON DELETE CASCADE
    add_foreign_key :chooses, :ristoratoris, on_delete: :cascade
    add_foreign_key :chooses, :tags, on_delete: :cascade
    add_foreign_key :dishes, :categories, on_delete: :cascade
    add_foreign_key :eventos, :ristoratoris, column: :owner, on_delete: :cascade
    add_foreign_key :problems, :users, column: :id_utente, on_delete: :cascade
    add_foreign_key :promotions, :ristoratoris, column: :ristoratore_id, on_delete: :cascade
  end
end
