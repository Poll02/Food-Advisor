class ChangeForeignKeyInPromotions < ActiveRecord::Migration[6.1]
  def change
    remove_column :promotions, :id_ristorante, :integer

    add_column :promotions, :ristoratore_id, :integer
    add_foreign_key :promotions, :ristoratoris, column: :ristoratore_id
    add_index :promotions, :ristoratore_id
  end
end
