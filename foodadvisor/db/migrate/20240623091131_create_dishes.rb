class CreateDishes < ActiveRecord::Migration[6.1]
  def change
    create_table :dishes do |t|
      t.string :name
      t.decimal :price, precision: 8, scale: 2
      t.string :ingredients
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
