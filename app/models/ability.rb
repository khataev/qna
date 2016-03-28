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
    can :vote_for, [Question, Answer] { |votable| votable.author != user }
    can :vote_against, [Question, Answer] { |votable| votable.author != user }
    can :vote_back, [Question, Answer] { |votable| votable.author != user }
  end

  def as_guest
    can :read, [Question, Answer, Comment]
  end

  def as_user(user)
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], author: user
    can :destroy, [Question, Answer, Comment], author: user
    can :destroy, Attachment do |attachment|
      attachment.attachable.author == user
    end
    can :set_best, Answer do |answer|
      answer.question.author == user
    end

    can_vote(user)
  end
end
