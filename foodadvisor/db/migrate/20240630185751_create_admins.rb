class CreateAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :admins do |t|
      t.references :utente, null: false, foreign_key: true
      t.string :nome
      t.string :cognome

      t.timestamps
    end
  end
end
