class CreateDishes < ActiveRecord::Migration[6.1]
  def change
    create_table :dishes do |t|
      t.string :name
      t.decimal :price
      t.text :ingredients
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
