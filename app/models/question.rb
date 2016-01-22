# Model for Question
class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { minimum: 10 }
end
