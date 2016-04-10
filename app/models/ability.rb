# Class for CanCanCan Abilities
class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      as_guest
      as_user(user)
    else
      as_guest
    end
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  private

  def can_vote(user)
    can :vote_for, [Question, Answer] { |votable| votable.user_id != user.id && !votable.user_voted?(user) }
    can :vote_against, [Question, Answer] { |votable| votable.user_id != user.id && !votable.user_voted?(user) }
    can :vote_back, [Question, Answer] { |votable| votable.user_id != user.id && votable.user_voted?(user) }
  end

  def can_subscribe_question(user)
    can :subscribe_on, [Question] { |question| !question.subscriptions.exists?(user_id: user.id) }
    can :unsubscribe_from, [Question] { |question| question.subscriptions.exists?(user_id: user.id) }
  end

  def as_guest
    can :read, [Question, Answer, Comment]
  end

  def as_user(user)
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :destroy, Attachment, attachable: { user_id: user.id }
    can :destroy, Subscription, user_id: user.id
    can :set_best, Answer, question: { user_id: user.id }

    can :me, User
    can :all_but_me, User

    can_vote(user)
    can_subscribe_question(user)
  end
end
