class ChangeFotoBinaryToString < ActiveRecord::Migration[6.1]
  def change
    change_column :ristoratoris, :foto, :string
  end
end
