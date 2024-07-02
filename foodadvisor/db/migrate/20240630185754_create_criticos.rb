class CreateCriticos < ActiveRecord::Migration[6.1]
  def change
    create_table :criticos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :certificato

      t.timestamps
    end
  end
end
