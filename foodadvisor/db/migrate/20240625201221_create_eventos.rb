class CreateEventos < ActiveRecord::Migration[6.1]
  def change
    create_table :eventos do |t|
      t.integer :owner, null: false, foreign_key: { to_table: :ristoratoris }
      t.string :nome, null: false
      t.date :data, null: false
      t.string :luogo, null: false
      t.string :descrizione

      t.timestamps
    end

    add_foreign_key :eventos, :ristoratoris, column: :owner
  end
end
