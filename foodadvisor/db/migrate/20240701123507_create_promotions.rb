class CreatePromotions < ActiveRecord::Migration[6.1]
  def change
    create_table :promotions do |t|
      t.date :data_inizio
      t.date :data_fine
      t.string :condizioni
      t.string :tipo
      t.references :ristoratore, null: false, foreign_key: true

      t.timestamps
    end
  end
end
