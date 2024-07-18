class Promotion < ApplicationRecord
  belongs_to :ristoratore

  validates :condizioni, presence: { message: "non può essere vuoto" }
  validates :tipo, presence: { message: "non può essere vuoto" }
  validates :data_inizio, presence: { message: "non può essere vuoto" }
  validates :data_fine, presence: { message: "non può essere vuoto" }

  validate :data_inizio_must_be_today_or_later
  validate :data_fine_must_be_after_data_inizio

  private

  def data_inizio_must_be_today_or_later
    if data_inizio.present? && data_inizio < Date.today
      errors.add(:data_inizio, 'deve essere maggiore o uguale alla data odierna')
    end
  end

  def data_fine_must_be_after_data_inizio
    if data_inizio.present? && data_fine.present? && data_fine <= data_inizio
      errors.add(:data_fine, 'deve essere successiva alla data di inizio')
    end
  end
end
