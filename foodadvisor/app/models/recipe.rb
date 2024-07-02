# app/models/recipe.rb
class Recipe < ApplicationRecord
    belongs_to :ristoratori, class_name: 'Ristoratori', foreign_key: 'ristoratore_id'
  
    validates :name, presence: true
    validates :difficulty, presence: true
    validates :ingredients, presence: true
    validates :procedure, presence: true
    validates :ristoratore_id, presence: true
  end
  