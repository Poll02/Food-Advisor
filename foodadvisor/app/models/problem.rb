class Problem < ApplicationRecord
    belongs_to :user, foreign_key: :id_utente
  end
  