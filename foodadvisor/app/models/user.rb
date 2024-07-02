class User < ApplicationRecord
    has_secure_password
    has_many :competizioni, foreign_key: 'owner'
    has_many :problems, foreign_key: :id_utente
    has_many :user_competitions
    has_many :competitions, through: :user_competitions


    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
          user.provider = auth.provider
          user.uid = auth.uid
          user.name = auth.info.name
          user.oauth_token = auth.credentials.token
          user.oauth_expires_at = Time.at(auth.credentials.expires_at)
          user.save
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
  