class User < ApplicationRecord
  attr_reader :password

  has_many :posts
  has_many :comments

  validates :username,        presence: true, uniqueness: true
  validates :email,           presence: true, uniqueness: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password,        length: { minimum: 8, allow_nil: true }
  validates :session_token,   presence: true, uniqueness: true
  validates :auth_token,      presence: true, uniqueness: true

  after_initialize :ensure_tokens

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)

    return nil if user.nil?

    user.is_password?(password) ? user : nil
  end

  def self.generate_token
    SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password = password

    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def reset_tokens!
    self.session_token  = self.class.generate_token
    self.auth_token     = self.class.generate_token
    self.save!
  end

  private

  def ensure_tokens
    self.session_token  ||= self.class.generate_token
    self.auth_token     ||= self.class.generate_token
  end
end
