# Model for Answer
class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  validates :body, presence: true, length: { minimum: 10 }
  validates :question_id, presence: true
  validates :user_id, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  def make_the_best
    ActiveRecord::Base.transaction do
      question.answers.update_all(best: false) unless best?
      update!(best: best? ? false : true)
    end
  end
end
