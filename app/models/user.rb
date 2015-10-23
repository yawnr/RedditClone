class User < ActiveRecord::Base
 attr_reader :password
 after_initialize :ensure_session_token

 validates :password_digest, presence: true
 validates(
   :password,
   length: { minimum: 6, allow_nil: true }
 )
 validates :session_token, presence: true, uniqueness: true
 validates :name, presence: true, uniqueness: true

  has_many(
     :subs,
     class_name: "Sub",
     foreign_key: :moderator_id,
     primary_key: :id
   )

  def self.find_by_credentials(name, password)
    user = User.find_by(name: name)
    return nil if user.nil?
    return user if user.is_password?(password)
    nil
  end

  def generate_token
    SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = generate_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
