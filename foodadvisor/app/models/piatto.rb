class Piatto < ApplicationRecord
    belongs_to :menu
  
    validates :nome, presence: true
    validates :prezzo, presence: true
  end