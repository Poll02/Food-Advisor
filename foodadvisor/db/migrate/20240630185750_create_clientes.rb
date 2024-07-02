class CreateClientes < ActiveRecord::Migration[6.1]
  def change
    create_table :clientes do |t|
      t.references :utente, null: false, foreign_key: true
      t.string :foto
      t.date :dataiscrizione

      t.timestamps
    end
  end
end
