class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :cliente, foreign_key: true
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
