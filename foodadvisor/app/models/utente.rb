class Utente < ApplicationRecord
    has_secure_password

    validates :email, presence: { message: "non può essere vuota" }, uniqueness: { message: "già presente nel database" }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "non è valida" }
    validates :password, presence: { message: "non può essere vuota" }, length: { minimum: 4, message: "deve essere lunga almeno 4 caratteri" }, format: { with: /(?=.*[A-Z])/, message: "non è valida" },  if: -> { new_record? || changes[:password] }
    validates :password_confirmation, presence: { message: "non può essere vuota" },  if: -> { new_record? || changes[:password_confirmation] }
    validates :telefono, uniqueness: { message: "già presente nel database" }, format: { with: /\A[0-9+\(\)#\.\s\/ext-]+$\z/, message: "non è valido" }

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
  