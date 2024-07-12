class Premi < ApplicationRecord
  belongs_to :user
  belongs_to :ristoratore

  validates :nomecompetizione, presence: true
  validates :nome, presence: true
  validates :data_inizio, presence: true
  validate :data_fine_after_data_inizio

  before_validation :set_data_fine

  private

  def set_data_fine
    self.data_fine = self.data_inizio + 3.months if self.data_inizio.present?
  end

  def data_fine_after_data_inizio
    if data_inizio.present? && data_fine.present? && data_fine <= data_inizio
      errors.add(:data_fine, "must be after the data_inizio")
    end
  end
end
