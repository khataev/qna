# Model for Question
class Question < ActiveRecord::Base
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { minimum: 10 }
  validates :user_id, presence: true

  after_create :subscribe_author

  scope :last_day_questions, -> { where('created_at >= ? ', 24.hours.ago) }

  def user_subscription(user)
    subscriptions.find_by(user: user)
  end

  private

  def subscribe_author
    subscriptions.create(user: author)
  end

  # def as_json(_options = {})
  #   super(only: [:id, :title, :body, :created_at, :updated_at])
  # end
end
