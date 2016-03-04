# Model for Question
class Question < ActiveRecord::Base
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { minimum: 10 }
  validates :user_id, presence: true

  def as_json(_options = {})
    super(only: [:id, :title, :body])
  end
end
