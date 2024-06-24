class RenameCompetizionesToCompetizione < ActiveRecord::Migration[6.1]
  def change
    rename_table :competizione, :competiziones

  end
end
