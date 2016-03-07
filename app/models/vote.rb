# Model for Vote
class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :user_votes, -> (user) { where(user: user) }
end
