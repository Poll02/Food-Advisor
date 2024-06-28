class Tag < ApplicationRecord
  has_many :chooses
  has_many :ristoratoris, through: :chooses
  end