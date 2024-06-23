class RenameSizeToFontSizeInSettings < ActiveRecord::Migration[6.1]
  def change
    rename_column :settings, :size, :font_size
  end
end
