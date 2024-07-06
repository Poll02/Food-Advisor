class CreateSegnalazione < ActiveRecord::Migration[6.1]
  def change
    create_table :segnalaziones do |t|
      t.references :recensione, null: false, foreign_key: true
      t.references :cliente, null: false, foreign_key: true
      t.string :motivo
      t.timestamps
    end
  end
end
