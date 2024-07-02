class CreateChooses < ActiveRecord::Migration[6.1]
  def change
    create_table :chooses do |t|
      t.references :ristoratore, null: false, foreign_key: { on_delete: :cascade }
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
