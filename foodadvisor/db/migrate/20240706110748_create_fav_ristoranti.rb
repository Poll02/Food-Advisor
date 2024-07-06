class CreateFavRistoranti < ActiveRecord::Migration[6.1]
  def change
    create_table :fav_ristorantis do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ristoratore, null: false, foreign_key: true

      t.timestamps
    end
  end
end
