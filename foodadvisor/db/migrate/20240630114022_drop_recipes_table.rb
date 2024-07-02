class DropRecipesTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :recipes
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
