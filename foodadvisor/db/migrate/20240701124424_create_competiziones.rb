class CreateCompetiziones < ActiveRecord::Migration[6.1]
  def change
    create_table :competiziones do |t|
      t.string :nome
      t.string :descrizione
      t.string :locandina
      t.string :requisiti
      t.string :premio
      t.integer :quantitareq, default: 0
      t.datetime :data_inizio
      t.datetime :data_fine
      t.references :ristoratore, null: false, foreign_key: true

      t.timestamps
    end
  end
end
