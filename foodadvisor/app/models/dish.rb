class Dish < ApplicationRecord
  belongs_to :menu

  validates :name, :price, :ingredients, presence: true
end
