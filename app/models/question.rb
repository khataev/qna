# Model for Question
class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { minimum: 10 }
  validates :author, presence: true
end
