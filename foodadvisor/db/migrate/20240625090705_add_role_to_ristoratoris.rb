class AddRoleToRistoratoris < ActiveRecord::Migration[6.1]
  def change
    add_column :ristoratoris, :role, :string
  end
end
