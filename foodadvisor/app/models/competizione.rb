class Competizione < ApplicationRecord
  belongs_to :ristoratore

  validates :nome, presence: true
  validates :descrizione, presence: true
  validates :premio, presence: true
  validates :data_inizio, presence: true
  validates :data_fine, presence: true
  #validate :date_range

  has_many :user_competitions
  has_many :users, through: :user_competitions

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
end
