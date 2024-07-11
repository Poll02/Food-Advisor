class CreatePrenotaziones < ActiveRecord::Migration[6.0]
  def change
    create_table :prenotaziones do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ristoratore, null: false, foreign_key: true
      t.integer :numero_persone, null: false
      t.date :data, null: false
      t.time :orario, null: false
      t.boolean :valida, null: false, default: false

      t.timestamps
    end
  end
end
