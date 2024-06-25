class Category < ApplicationRecord
    has_many :dishes, dependent: :destroy
  end
  