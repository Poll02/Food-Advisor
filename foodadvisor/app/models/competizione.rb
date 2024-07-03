class Competizione < ApplicationRecord
    belongs_to :ristoratore

    has_many :user_competitions
    has_many :users, through: :user_competitions
  end
  