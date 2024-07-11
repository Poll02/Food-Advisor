class CreatePiattos < ActiveRecord::Migration[6.1]
  def change
    create_table :piattos do |t|
      t.references :menu, null: false, foreign_key: true
      t.string :nome
      t.float :prezzo
      t.string :foto
      t.string :ingredienti
      t.string :categoria

      t.timestamps
    end
  end
end
