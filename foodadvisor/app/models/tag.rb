class Tag < ApplicationRecord
    has_many :chooses, dependent: :destroy

  end
  