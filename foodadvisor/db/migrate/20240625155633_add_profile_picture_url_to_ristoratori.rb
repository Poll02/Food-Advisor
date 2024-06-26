class AddProfilePictureUrlToRistoratori < ActiveRecord::Migration[6.1]
  def change
    add_column :ristoratoris, :profile_picture_url, :string
  end
end
