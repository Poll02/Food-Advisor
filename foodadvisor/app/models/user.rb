class User < ApplicationRecord
    has_secure_password
    has_many :competizioni, foreign_key: 'owner'

    def self.from_omniauth(auth)
      where(email: auth.info.email).first_or_initialize do |user|
        user.email = auth.info.email
        user.name = auth.info.name
        user.password = SecureRandom.hex(10) unless user.persisted?
        user.save!
      end
    end
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }
  end
  