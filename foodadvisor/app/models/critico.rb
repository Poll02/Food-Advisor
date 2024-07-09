class Critico < ApplicationRecord
    belongs_to :user

    validates :certificato, presence: true
  end
  