class CreateProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :problems do |t|
      t.string :text
      t.boolean :stato, null: false, default: false
      t.references :cliente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
