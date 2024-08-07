class CreateRecensione < ActiveRecord::Migration[6.1]
  def change
    create_table :recensiones do |t|
      t.references :cliente, null: false, foreign_key: true
      t.references :ristoratore, null: false, foreign_key: true
      t.string :commento
      t.boolean :pinnata, default: false
      t.integer :stelle
      t.integer :like, default: 0

      t.timestamps
    end
  end
end
