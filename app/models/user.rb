# Model for User
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :authorizations
  # validates :password, :password_confirmation, presence: true

  def self.find_for_oauth(auth, reset_confirmation = false)
    auth = get_auth_params_from(auth)

    authorization = Authorization.where(provider: auth[:provider], uid: auth[:uid]).first
    return authorization.user if authorization

    email = auth[:email]
    return nil unless email

    user = User.where(email: email).first

    if user
      user.confirmed_at = nil if reset_confirmation
      user.save! if reset_confirmation
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password, confirmed_at: Time.now)
    end
    user.create_authorization(auth)

    user
  end

  def author_of?(obj)
    return false unless obj.respond_to? :user_id
    obj.user_id == id
  end

  def create_authorization(auth)
    authorizations.create(provider: auth[:provider], uid: auth[:uid])
  end

  # TODO: Test
  def self.get_auth_params_from(source)
    hash = {}
    if source.is_a?(OmniAuth::AuthHash)
      hash[:email] = source.info[:email] unless source.info.nil?
      hash[:uid] = source.uid.to_s
      hash[:provider] = source.provider
    else
      hash[:email] = source[:email]
      hash[:uid] = source[:uid].to_s
      hash[:provider] = source[:provider]
    end

    hash
  end
end
