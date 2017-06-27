class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence:true,
                    length: { minimum: 4, maximum: 400 }
  validates :username, presence:true,
                    length: { minimum: 4, maximum: 90 },
                    uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence:true, length: { maximum: 256 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
end
