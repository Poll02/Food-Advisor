class AddPartitaIvaToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :partita_iva, :string
  end
end
