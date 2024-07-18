class Evento < ApplicationRecord
    belongs_to :ristoratore
  
    validates :luogo, presence: { message: "non può essere vuoto" }
    validates :nome, presence: { message: "non può essere vuoto" }
    validates :data, presence: { message: "non può essere vuoto" }
  
    validate :data_must_be_in_the_future
  
    private
  
    def data_must_be_in_the_future
      if data.present? && data <= Date.today
        errors.add(:data, 'deve essere una data futura')
      end
    end
end
  