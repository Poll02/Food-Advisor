class CreateChooses < ActiveRecord::Migration[6.1]
  def change
    create_table :chooses, id: false do |t|
      t.references :ristoratori, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
    end
    add_index :chooses, [:ristoratori_id, :tag_id], unique: true
  end
end
