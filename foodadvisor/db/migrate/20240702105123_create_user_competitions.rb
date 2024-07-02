class CreateUserCompetitions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_competitions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :competizione, null: false, foreign_key: { on_delete: :cascade }
      t.integer :punti, default: 0

      t.timestamps 
    end
  end
end
