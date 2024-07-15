class Dipendente < ApplicationRecord
  belongs_to :ristoratore

  # Validazioni
  validates :nome, presence: true
  validates :cognome, presence: true
  validates :assunzione, presence: true
  validates :ruolo, presence: true, inclusion: { in: %w(fattorino cameriere cassiere sommelier cuoco lavapiatti direttore\ di\ sala aiuto-chef) }

  validate :dataassunzione_non_nel_futuro

  private

  def dataassunzione_non_nel_futuro
    if assunzione.present? && assunzione > Date.today
      errors.add(:assunzione, "non può essere una data futura")
    end
  end
end
