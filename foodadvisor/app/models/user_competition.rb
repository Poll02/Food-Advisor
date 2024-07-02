# app/models/user_competition.rb
class UserCompetition < ApplicationRecord
    belongs_to :user
    belongs_to :competizione
  
    validates :user_id, presence: true
    validates :competizione_id, presence: true
  end
  