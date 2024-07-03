# app/models/recensione.rb (o il nome corretto del modello)
class Recensione < ApplicationRecord
  belongs_to :cliente
  belongs_to :ristoratore
  belongs_to :competizione, optional: true
  # Altre associazioni e validazioni
  validates :cliente_id, presence: true
  validates :ristoratore_id, presence: true
  validates :stelle, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :commento, presence: true, length: { minimum: 0, maximum: 500 }

  delegate :user, to: :cliente, prefix: true
end
  