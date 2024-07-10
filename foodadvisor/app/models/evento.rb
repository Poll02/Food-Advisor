class Evento < ApplicationRecord
    belongs_to :ristoratore
    has_many :fav_event, dependent: :destroy
  has_many :favorited_by_users, through: :fav_event, source: :user
  end
  