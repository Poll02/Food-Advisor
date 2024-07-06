class User < ApplicationRecord
    belongs_to :cliente
    
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
  end
  