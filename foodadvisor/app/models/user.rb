class User < ApplicationRecord
    has_secure_password
    has_many :competizioni, foreign_key: 'owner'
    has_many :problems, foreign_key: :id_utente


    def self.from_omniauth(auth)
      where(email: auth.info.email).first_or_initialize do |user|
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = SecureRandom.hex(10) unless user.persisted?
        user.role = 'user' # Imposta un valore di default, o cambia secondo la tua logica
        user.save!
      end
    end
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }

    # Metodo authenticate
    def authenticate(password)
      # implementazione di base di has_secure_password
      return self if BCrypt::Password.new(password_digest) == password
    end
  end
  