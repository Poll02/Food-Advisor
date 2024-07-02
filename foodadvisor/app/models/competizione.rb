class Competizione < ApplicationRecord
    belongs_to :owner, class_name: 'User', foreign_key: 'owner'
    has_many :user_competitions
    has_many :users, through: :user_competitions
  
    validates :nome, presence: true
    validates :descrizione, presence: true
    validates :locandina, presence: true
    validates :requisiti, presence: true
    validates :premio, presence: true
    validates :tag, presence: true
    validates :data_inizio, presence: true
    validates :data_fine, presence: true
  end
  