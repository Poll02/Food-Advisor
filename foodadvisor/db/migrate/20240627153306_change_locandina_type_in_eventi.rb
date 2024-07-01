class ChangeLocandinaTypeInEventi < ActiveRecord::Migration[6.1]
  def change
    change_column :eventos, :locandina, :string
  end
end
