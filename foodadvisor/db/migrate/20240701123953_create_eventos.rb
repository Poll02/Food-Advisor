class CreateEventos < ActiveRecord::Migration[6.1]
  def change
    create_table :eventos do |t|
      t.string :nome, null: false
      t.date :data, null: false
      t.string :luogo, null: false
      t.string :descrizione
      t.string :locandina
      t.references :ristoratore, null: false, foreign_key: true

      t.timestamps
    end
  end
end
