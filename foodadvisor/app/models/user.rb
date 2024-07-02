class User < ApplicationRecord
    belongs_to :cliente
    
    has_one :critico
    has_many :user_competitions
    has_many :competiziones, through: :user_competitions

    accepts_nested_attributes_for :critico
  end
  