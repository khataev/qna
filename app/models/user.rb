# Model for User
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  has_many :answers
  # validates :password, :password_confirmation, presence: true

  def author_of?(obj)
    return false unless obj.respond_to? :user_id
    obj.user_id == id
  end
end
