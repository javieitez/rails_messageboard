class User < ApplicationRecord

  VALID_EMAIL = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  NO_SPACES = /\A[a-zA-Z0-9]+\z/

  before_save { self.email = email.downcase }
  validates :name, presence:true,
                    length: { minimum: 4, maximum: 400 }
  validates :username, presence:true,
                    length: { minimum: 4, maximum: 90 },
                    format: { with: NO_SPACES },
                    uniqueness: { case_sensitive: false }

  validates :email, presence:true, length: { maximum: 256 },
                        format: { with: VALID_EMAIL },
                        uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
end
