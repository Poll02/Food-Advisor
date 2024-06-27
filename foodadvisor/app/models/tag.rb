class Tag < ApplicationRecord
    has_many :chooses
    has_many :ristoratori, through: :Chooses
  end