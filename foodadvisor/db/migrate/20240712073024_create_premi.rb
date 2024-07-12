class CreatePremi < ActiveRecord::Migration[6.1]
  def change
    create_table :premis do |t|
      t.string :nomecompetizione
      t.string :nome
      t.date :data_inizio
      t.date :data_fine
      t.references :user, null: false, foreign_key: true
      t.references :ristoratore, null: false, foreign_key: true

      t.timestamps
    end
  end
end
