class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.date :birth
      t.string :email
      t.string :phone
      t.string :password_digest

      t.timestamps
    end
  end
end
