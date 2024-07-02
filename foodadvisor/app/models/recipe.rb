# app/models/recipe.rb
class Recipe < ApplicationRecord
    belongs_to :ristoratore
    
    # Validazioni
    validates :name, :difficulty, :ingredients, :procedure, presence: true
  end
  