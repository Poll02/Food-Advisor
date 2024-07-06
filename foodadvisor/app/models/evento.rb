class Evento < ApplicationRecord
    belongs_to :ristoratore
    has_many :fav_events, dependent: :destroy
  has_many :favorited_by_users, through: :fav_events, source: :user
  end
  