class Tag < ApplicationRecord
  has_many :chooses, foreign_key: :tag_id
  has_many :ristoratori, through: :chooses
  end