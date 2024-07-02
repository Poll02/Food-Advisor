class Utente < ApplicationRecord
    has_secure_password

    has_one :cliente, dependent: :destroy
    has_one :admin, dependent: :destroy

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
  