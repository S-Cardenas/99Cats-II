class User < ActiveRecord::Base
  attr_reader :password

  validates :username, :session_token, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  before_validation :ensure_session_token

  has_many(
    :cats,
    class_name: "Cat",
    primary_key: :id,
    foreign_key: :user_id
  )

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save!
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    return user if user.password_digest.is_password?(password)
    nil
  end

  def password_digest
    BCrypt::Password.new(super)
  end


end
