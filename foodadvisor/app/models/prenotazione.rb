class Prenotazione < ApplicationRecord
  belongs_to :user
  belongs_to :ristoratore

  validates :numero_persone, presence: { message: "non può essere vuoto" }, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20, message: "deve essere compreso tra 1 e 20" }
  validates :data, presence: { message: "non può essere vuoto" }
  validate :data_non_nel_passato
  validates :orario, presence: { message: "non può essere vuoto" }

  private

  def data_non_nel_passato
    errors.add(:data, "deve essere maggiore o uguale alla data odierna") if data.present? && data < Date.today
  end
end
