class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.references :cliente, null: false, foreign_key: true
      t.string :username
      t.string :nome
      t.string :cognome
      t.date :datanascita
      t.integer :punti, default: 0

      t.timestamps
    end
  end
end
