class AddFacebookFieldsToUtentes < ActiveRecord::Migration[6.1]
  def change
    add_column :utentes, :facebook_id, :string
    add_column :utentes, :name, :string
  end
end
