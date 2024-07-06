class FavRistoranti < ApplicationRecord
    belongs_to :user
    belongs_to :ristoratore
  end
  