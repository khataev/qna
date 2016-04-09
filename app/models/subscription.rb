# class for Subscription
class Subscription < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates_presence_of :user_id, :question_id
end
