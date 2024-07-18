class CreateAnswer < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.references :recensione, null: false, foreign_key: true
      t.references :ristoratore, null: false, foreign_key: true
      t.string :risposta
      t.timestamps
    end
  end
end
