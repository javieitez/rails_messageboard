class User < ApplicationRecord

  VALID_EMAIL = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  NO_SPACES = /\A[a-zA-Z0-9]+\z/

  attr_accessor :remember_token
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
  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the DB for persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  #forgets a user, to be set on log_out and remember == 0
  def forget
    update_attribute(:remember_digest, nil)
  end

end