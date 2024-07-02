class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.string :difficulty, null: false
      t.string :ingredients, null: false
      t.string :procedure, null: false
      t.string :photo
      t.integer :ristoratore_id

      t.timestamps
    end
    add_foreign_key :recipes, :ristoratoris, column: :ristoratore_id

  end
end
