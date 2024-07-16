class Competizione < ApplicationRecord

  VALID_REQUISITI = ['nessuno', 'prenotazioni', 'recensioni', 'punti']

  belongs_to :ristoratore

  validates :nome, presence: true
  validates :descrizione, presence: true
  validates :premio, presence: true
  validates :data_inizio, presence: true
  validates :data_fine, presence: true
  #validate :date_range: per quando li creiamo noi 
  validates :requisiti, inclusion: { in: VALID_REQUISITI, message: 'deve essere uno tra: nessuno, prenotazioni, recensioni, punti' }
  validate :quantitareq_validity

  has_many :user_competitions,  dependent: :destroy
  has_many :users, through: :user_competitions

  def posizione_utente(user_id)
    # Ordina le user_competitions per punti in ordine decrescente e crea un array di user_ids
    posizioni = user_competitions.order(punti_competizione: :desc).pluck(:user_id)

    # Trova la posizione dell'utente nell'array (0-based, quindi aggiungi 1)
    posizioni.index(user_id) + 1
  end

  private

  def date_range
    if data_inizio.present? && data_fine.present?
      if data_inizio < Date.today
        errors.add(:data_inizio, "deve essere maggiore o uguale alla data odierna")
      end

      if data_fine <= data_inizio
        errors.add(:data_fine, "deve essere maggiore della data di inizio")
      end
    end
  end

  def quantitareq_validity
    if requisiti == 'nessuno'
      errors.add(:quantitareq, 'deve essere 0 se i requisiti sono nessuno') unless quantitareq == 0
    else
      errors.add(:quantitareq, 'deve essere maggiore di 0 se i requisiti non sono nessuno') unless quantitareq > 0
    end
  end
end
