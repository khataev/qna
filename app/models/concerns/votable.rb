# Module Votable gives model an ability to be voted for
module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :delete_all, as: :votable
  end

  # region Properties
  def rating
    likes.count - dislikes.count
  end

  def likes
    votes.where(like: true)
  end

  def dislikes
    votes.where(like: false)
  end

  def voted_by?(user)
    votes.where(user: user).count > 0
  end
  # endregion

  # region Methods
  def vote_for(user)
    vote(user, true)
  end

  def vote_against(user)
    vote(user, false)
  end

  def vote_back(user)
    Vote.delete_all(votable: self, user: user)
  end

  def as_json(options = {})
    super(options.merge(methods: [:rating]))
  end
  # endregion

  # region Private
  private

  def model_klass
    self.class
  end

  def model_klass_name
    self.class.to_s
  end

  def user_voted?(user)
    Vote.where(votable: self, user: user).count > 0
  end

  def vote(user, like)
    if author.id == user.id
      errors[:base] << "You can't vote for your #{model_klass_name}"
      false
    elsif user_voted?(user)
      errors[:base] << 'You can vote only once'
      false
    else
      vote = votes.build(user: user, like: like)
      vote.save!
      true
    end
  end
  # endregion
end
