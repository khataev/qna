# model for Comment
class Comment < ActiveRecord::Base
  # associations
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :commentable, polymorphic: true

  # validations
  validates :body, presence: true, length: { minimum: 10, maximum: 100 }
  validates :user_id, presence: true

  default_scope { order(created_at: :asc) }
end
