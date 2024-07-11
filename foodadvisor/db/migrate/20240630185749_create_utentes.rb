class CreateUtentes < ActiveRecord::Migration[6.1]
  def change
    create_table :utentes do |t|
      t.string :email
      t.string :password_digest
      t.string :telefono

      t.timestamps
    end
  end
end
