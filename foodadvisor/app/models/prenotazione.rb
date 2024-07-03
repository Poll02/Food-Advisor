class Prenotazione < ApplicationRecord
    belongs_to :user
    belongs_to :ristoratore
  
    validates :numero_persone, presence: true
    validates :data, presence: true
    validates :orario, presence: true
  end
  