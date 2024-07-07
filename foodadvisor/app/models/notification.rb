class Notification < ApplicationRecord
    belongs_to :cliente

    # Validazioni opzionali
  validates :email, presence: true
  validates :message, presence: true
end