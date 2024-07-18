class Critico < ApplicationRecord
    belongs_to :user

    validates :certificato, presence: { message: "non può essere vuoto" }
  end
  