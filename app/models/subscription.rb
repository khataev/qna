# class for Subscription
class Subscription < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :user_id, :question_id, presence: true
end
