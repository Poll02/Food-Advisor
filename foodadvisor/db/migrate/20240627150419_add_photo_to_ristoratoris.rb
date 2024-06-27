class AddPhotoToRistoratoris < ActiveRecord::Migration[6.1]
  def change
    add_column :ristoratoris, :photo, :string
  end
end
