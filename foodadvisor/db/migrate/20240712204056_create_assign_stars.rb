class CreateAssignStars < ActiveRecord::Migration[6.0]
  def change
    create_table :assign_stars do |t|
      t.references :cliente, foreign_key: true
      t.references :recensione, foreign_key: true

      t.timestamps
    end
  end
end
