class AddAddressToRistoratori < ActiveRecord::Migration[6.1]
  def change
    add_column :ristoratoris, :address, :string
  end
end
