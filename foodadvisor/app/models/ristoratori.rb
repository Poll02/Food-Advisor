# app/models/ristoratori.rb

class Ristoratori < ApplicationRecord
    has_secure_password
    has_many :eventos, foreign_key: 'owner'
    has_many :promotions, foreign_key: 'ristoratore_id'
    has_many :chooses
    has_many :tags, through: :chooses

    
    validates :restaurant_name, presence: true
    validates :piva, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :phone, presence: true
    validates :password, presence: true, length: { minimum: 6 }

    # Metodo authenticate
    def authenticate(password)
      # implementazione di base di has_secure_password
      return self if BCrypt::Password.new(password_digest) == password
    end
  end
  