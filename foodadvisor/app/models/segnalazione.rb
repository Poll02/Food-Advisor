class Segnalazione < ApplicationRecord
    belongs_to :cliente
    belongs_to :recensione

    validates :motivo, presence: true, length: { minimum: 1, maximum: 500 }
end