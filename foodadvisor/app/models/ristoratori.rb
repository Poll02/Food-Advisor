# app/models/ristoratori.rb

class Ristoratori < ApplicationRecord
    has_secure_password
    
    validates :restaurant_name, presence: true
    validates :piva, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :phone, presence: true
    validates :password, presence: true, length: { minimum: 6 }
  end
  