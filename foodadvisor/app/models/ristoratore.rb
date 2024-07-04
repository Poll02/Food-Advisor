class Ristoratore < ApplicationRecord
    belongs_to :cliente

    has_many :promotions, dependent: :destroy
    has_many :eventos, dependent: :destroy
    has_many :competiziones, dependent: :destroy
    has_many :chooses, dependent: :destroy
    has_many :tags, through: :chooses
    has_many :recipes, dependent: :destroy
    has_many :dipendentes, dependent: :destroy
    has_many :prenotaziones, dependent: :destroy
    has_one :menu, dependent: :destroy
    
    after_create :create_associated_menu

    private

    def create_associated_menu
      create_menu
    end

  end
  