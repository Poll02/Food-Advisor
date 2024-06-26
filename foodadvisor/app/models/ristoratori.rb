# app/models/ristoratori.rb

class Ristoratori < ApplicationRecord
    has_secure_password
    
    validates :restaurant_name, presence: true
    validates :piva, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :phone, presence: true
    validates :password, presence: true, length: { minimum: 6 }

    has_one_attached :foto
    # Metodo authenticate
    def authenticate(password)
      # implementazione di base di has_secure_password
      return self if BCrypt::Password.new(password_digest) == password
    end
  end
  