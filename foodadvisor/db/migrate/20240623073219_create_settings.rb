class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.string :font
      t.string :size
      t.string :theme

      t.timestamps
    end
  end
end
