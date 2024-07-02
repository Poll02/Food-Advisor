class CreateRistoratores < ActiveRecord::Migration[6.1]
  def change
    create_table :ristoratores do |t|
      t.references :cliente, null: false, foreign_key: true
      t.string :piva
      t.boolean :asporto
      t.string :nomeristorante
      t.string :indirizzo

      t.timestamps
    end
  end
end
