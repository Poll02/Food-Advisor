class CreateProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :problems do |t|
      t.integer :id_utente
      t.string :text
      t.references :cliente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
