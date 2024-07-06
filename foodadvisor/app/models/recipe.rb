# app/models/recipe.rb
class Recipe < ApplicationRecord
    belongs_to :ristoratore
    
    # Validazioni
    validates :name, :difficulty, :ingredients, :procedure, presence: true
    has_many :fav_recipe, dependent: :destroy
  has_many :favorited_by_users, through: :fav_recipe, source: :user
  end
  