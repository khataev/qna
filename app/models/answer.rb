# Model for Answer
class Answer < ActiveRecord::Base
  default_scope { order(best: :desc, created_at: :asc) }

  include Attachable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :body, presence: true, length: { minimum: 10 }
  validates :question_id, presence: true
  validates :user_id, presence: true

  after_create :notify_subscribers

  def make_the_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false) unless best?
      update!(best: best? ? false : true)
    end
  end

  private

  def notify_subscribers
    QuestionSubscriptionJob.perform_later(self)
  end
end
