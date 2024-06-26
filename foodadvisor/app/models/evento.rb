class Evento < ApplicationRecord
    has_one_attached :locandina
  
    validates :owner, presence: true
    validates :nome, presence: true
    validates :data, presence: true
    validates :luogo, presence: true
    validates :descrizione, presence: true

    belongs_to :ristoratori, class_name: 'Ristoratori', foreign_key: 'owner'
  end
  