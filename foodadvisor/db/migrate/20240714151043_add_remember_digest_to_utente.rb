class AddRememberDigestToUtente < ActiveRecord::Migration[6.1]
  def change
    add_column :utentes, :remember_digest, :string
  end
end
