class Cliente < ApplicationRecord
    belongs_to :utente

    has_one :ristoratore, dependent: :destroy
    has_one :user, dependent: :destroy
    has_many :problems, dependent: :destroy
    has_many :assign_stars, dependent: :destroy
    has_many :recensione, dependent: :destroy
    has_many :notifications, dependent: :destroy
    has_many :segnalazione, dependent: :destroy
    has_many :segnalazioni_ricevute, class_name: 'Segnalazione', dependent: :destroy

    accepts_nested_attributes_for :user, :ristoratore
  end
  