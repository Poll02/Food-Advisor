class CreateDipendenti < ActiveRecord::Migration[6.0]
  def change
    create_table :dipendentes do |t|
      t.string :nome
      t.string :cognome
      t.string :foto
      t.string :ruolo
      t.date :assunzione
      t.references :ristoratore, null: false, foreign_key: true

      t.timestamps
    end
  end
end
