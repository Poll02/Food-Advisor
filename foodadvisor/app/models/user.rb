class User < ApplicationRecord
    belongs_to :cliente

    validates :username, presence: true, uniqueness: { message: "già in uso" }, length: { maximum: 20 }
    validates :nome, presence: true, length: { maximum: 20 }
    validates :cognome, presence: true, length: { maximum: 20 }
    validates :datanascita, presence: true
    validate :datanascita_must_be_in_the_past
    
    has_one :critico
    has_many :user_competitions
    has_many :competiziones, through: :user_competitions
    has_many :prenotaziones, dependent: :destroy
    has_many :fav_ristoranti, dependent: :destroy
    has_many :favorite_ristoranti, through: :fav_ristoranti, source: :ristoratore

    has_many :fav_recipe, dependent: :destroy
    has_many :favorite_recipes, through: :fav_recipe, source: :recipe

    has_many :fav_events, dependent: :destroy
    has_many :favorite_events, through: :fav_events, source: :event

    accepts_nested_attributes_for :critico

    private

    def datanascita_must_be_in_the_past
      if datanascita.present? && datanascita > Date.today
        errors.add(:datanascita, "deve essere una data passata o odierna")
      end
    end
    
  end
  