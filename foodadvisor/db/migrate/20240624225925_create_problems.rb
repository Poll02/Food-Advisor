class CreateProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :problems do |t|
      t.integer :id_utente
      t.string :text

      t.timestamps
    end

    add_foreign_key :problems, :users, column: :id_utente
    add_index :problems, :id_utente
    
  end
end
