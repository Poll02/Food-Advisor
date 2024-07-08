class Utente < ApplicationRecord
    has_secure_password

    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 4 }, format: { with: /(?=.*[A-Z])/ }
    validates :password_confirmation, presence: true
    validates :telefono, presence: true, uniqueness: true, format: { with: /\A[0-9+\(\)#\.\s\/ext-]+$\z/ }

    has_one :cliente, dependent: :destroy
    has_one :admin, dependent: :destroy
    has_one :user, through: :cliente
    has_one :ristoratore, through: :cliente

    has_one :setting, dependent: :destroy
    after_create :create_default_settings

    
    accepts_nested_attributes_for :cliente

    # Metodo authenticate
    def authenticate(password)
      # implementazione di base di has_secure_password
      return self if BCrypt::Password.new(password_digest) == password
    end

    private

    def create_default_settings
      create_setting(font: 'Poppins', font_size: 'medium', theme: 'day')
    end
  end
  