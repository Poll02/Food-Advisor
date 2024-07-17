class AddUidAndProviderToUtentes < ActiveRecord::Migration[6.1]
  def change
    add_column :utentes, :uid, :string
    add_column :utentes, :provider, :string
  end
end
