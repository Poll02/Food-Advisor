class Menu < ApplicationRecord
  self.table_name = 'menu'  # Assicurati che sia 'menu' e non 'menus'
  
  has_many :dishes, dependent: :destroy
  accepts_nested_attributes_for :dishes, allow_destroy: true

end