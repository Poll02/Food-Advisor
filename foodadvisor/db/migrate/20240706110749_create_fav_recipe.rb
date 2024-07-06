class CreateFavRecipe < ActiveRecord::Migration[6.1]
  def change
    create_table :fav_recipes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
