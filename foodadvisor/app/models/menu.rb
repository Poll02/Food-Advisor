class Menu < ApplicationRecord
    belongs_to :ristoratore
    has_many :piattos, dependent: :destroy
  end