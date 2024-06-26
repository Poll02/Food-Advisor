class CreatePromotions < ActiveRecord::Migration[6.1]
  def change
    create_table :promotions do |t|
      t.date :data_inizio
      t.date :data_fine
      t.string :condizioni
      t.string :tipo
      t.integer :id_ristorante

      t.timestamps
    end

    add_foreign_key :promotions, :users, column: :id_ristorante

  end
end
