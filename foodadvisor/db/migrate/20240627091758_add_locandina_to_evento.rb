class AddLocandinaToEvento < ActiveRecord::Migration[6.1]
  def change
    add_column :eventos, :locandina, :binary
  end
end
