# app/models/recensione.rb (o il nome corretto del modello)
class Answer < ApplicationRecord
    belongs_to :recensione
    belongs_to :ristoratore

    # Altre associazioni e validazioni
    validates :recensione, presence: true, uniqueness: true
    validates :ristoratore, presence: true
    validates :risposta, presence: true, length: { minimum: 1, maximum: 500 }

end
    