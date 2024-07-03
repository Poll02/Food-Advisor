class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.string :font, default: 'default_font'
      t.string :font_size, default: 'default_size'
      t.string :theme, default: 'default_theme'
      t.references :utente, null: false, foreign_key: true

      t.timestamps
    end
  end
end
