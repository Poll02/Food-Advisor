class RenameMenusToMenu < ActiveRecord::Migration[6.1]
  def change
    rename_table :menus, :menu
  end
end
