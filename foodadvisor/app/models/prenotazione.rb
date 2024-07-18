class Prenotazione < ApplicationRecord
  belongs_to :user
  belongs_to :ristoratore

  validates :numero_persone, presence: { message: "non può essere vuoto" }, numericality: { only_integer: true }
  validate :numero_persone_tra_1_e_20
  validates :data, presence: { message: "non può essere vuoto" }
  validates :orario, presence: { message: "non può essere vuoto" }
  validate :data_must_be_today_or_later
  validate :orario_must_be_later_if_today

  private

  def numero_persone_tra_1_e_20
    if numero_persone.present? && (numero_persone < 1 || numero_persone > 20)
      errors.add(:numero_persone, "deve essere compreso tra 1 e 20")
    end
  end

  def data_must_be_today_or_later
    errors.add(:data, 'deve essere maggiore o uguale alla data odierna') if data.present? && data < Date.today
  end

  def orario_must_be_later_if_today
    if data.present? && data == Date.today && orario.present? && orario < Time.now
      errors.add(:orario, 'deve essere un orario successivo ad ora se la data è oggi')
    end
  end

end
