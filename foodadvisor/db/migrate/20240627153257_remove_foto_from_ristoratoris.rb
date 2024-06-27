class RemoveFotoFromRistoratoris < ActiveRecord::Migration[6.1]
  def change
    remove_column :ristoratoris, :foto, :binary
  end
end
