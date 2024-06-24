class CreateCompetizione < ActiveRecord::Migration[6.1]
  def change
    create_table :competizione do |t|
      t.string :nome
      t.string :descrizione
      t.string :locandina
      t.string :requisiti
      t.string :premio 
      t.string :tag
      t.integer :owner, null: false, foreign_key: { to_table: :users }
      t.datetime :data_inizio
      t.datetime :data_fine

      t.timestamps
    end

    add_foreign_key :competizione, :users, column: :owner

  end
end
