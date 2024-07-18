class Segnalazione < ApplicationRecord
    belongs_to :cliente
    belongs_to :cliente_segnalato, class_name: 'Cliente'

    has_one :recensione

    validates :motivo, presence: true, length: { minimum: 1, maximum: 500 }
end