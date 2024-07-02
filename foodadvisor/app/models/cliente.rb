class Cliente < ApplicationRecord
    belongs_to :utente

    has_one :ristoratore, dependent: :destroy
    has_one :user, dependent: :destroy
    has_many :problems, dependent: :destroy

    accepts_nested_attributes_for :user, :ristoratore
  end
  