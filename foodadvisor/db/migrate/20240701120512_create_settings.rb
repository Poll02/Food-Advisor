class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.string :font, default: 'Arial'
      t.string :font_size, default: 'medium'
      t.string :theme, default: 'day'
      t.references :utente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
