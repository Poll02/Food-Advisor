class CreateRistoratori < ActiveRecord::Migration[6.1]
  def change
    create_table :ristoratoris do |t|
      t.string :restaurant_name, null: false
      t.integer :piva, null: false, limit: 8  # Usa 'integer' per i numeri interi
      t.string :email, null: false
      t.string :phone, null: false
      t.string :password_digest, null: false  # Usa 'password_digest' per l'autenticazione sicura
      t.binary :foto

      t.timestamps
    end
  end
end
