require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'Guest' do
    let(:user) { nil }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, Question }
    it { should_not be_able_to :subscribe_on, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :create, Subscription }
    it { should_not be_able_to :destroy, Subscription }

    # Site Search
    it { should be_able_to :show, Search }

    # API
    it { should_not be_able_to :me, User }
    it { should_not be_able_to :all_but_me, User }
  end

  describe 'User' do
    let!(:user) { create :user }
    let!(:other_user) { create :user }
    let(:my_question) { create(:question, author: user) }
    let(:my_answer) { create(:answer, author: user) }
    let(:my_comment) { create(:comment, author: user) }

    let(:foreign_question) { create(:question, author: other_user) }
    let(:foreign_answer) { create(:answer, author: other_user) }
    let(:foreign_comment) { create(:comment, author: other_user) }

    let(:answer_of_my_question) { create(:answer, question: my_question) }
    let(:answer_of_foreign_question) { create(:answer, question: foreign_question) }

    let(:attachment_of_my_question) { create(:question_with_file, author: user) }
    let(:attachment_of_foreign_question) { create(:question_with_file, author: other_user) }

    let(:voted_question) { create(:question_with_positive_vote, vote_author: user) }
    let(:voted_answer) { create(:answer_with_positive_vote, vote_author: user) }

    let(:subscribed_question) { create(:question_with_subscriber, subscriber: user) }
    let(:question_no_subscribers) { create(:question) }
    let(:user_subscription) { create(:subscription, user: user) }
    let(:another_user_subscription) { create(:subscription) }

    # like Guest
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    # Site Search
    it { should be_able_to :show, Search }

    # like User
    # create
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }
    it { should be_able_to :destroy, user_subscription }
    it { should_not be_able_to :destroy, another_user_subscription }

    # update
    it { should be_able_to :update, my_question }
    it { should be_able_to :update, my_answer }
    it { should be_able_to :update, my_comment }

    it { should_not be_able_to :update, foreign_question }
    it { should_not be_able_to :update, foreign_answer }
    it { should_not be_able_to :update, foreign_comment }

    # destroy
    it { should be_able_to :destroy, my_question }
    it { should be_able_to :destroy, my_answer }
    it { should be_able_to :destroy, my_comment }
    it { should be_able_to :destroy, attachment_of_my_question.attachments.first }
    it { should_not be_able_to :destroy, attachment_of_foreign_question.attachments.first }

    it { should_not be_able_to :destroy, foreign_question }
    it { should_not be_able_to :destroy, foreign_answer }
    it { should_not be_able_to :destroy, foreign_comment }

    # set_best
    it { should be_able_to :set_best, answer_of_my_question }
    it { should_not be_able_to :set_best, answer_of_foreign_question }

    it { should_not be_able_to :set_best, foreign_question }
    it { should_not be_able_to :set_best, foreign_answer }
    it { should_not be_able_to :set_best, foreign_comment }

    # vote_for
    it { should be_able_to :vote_for, foreign_question }
    it { should be_able_to :vote_for, foreign_answer }
    it { should_not be_able_to :vote_for, my_question }
    it { should_not be_able_to :vote_for, my_answer }
    it { should_not be_able_to :vote_for, voted_question }
    it { should_not be_able_to :vote_for, voted_answer }

    # vote_against
    it { should be_able_to :vote_against, foreign_question }
    it { should be_able_to :vote_against, foreign_answer }
    it { should_not be_able_to :vote_against, my_question }
    it { should_not be_able_to :vote_against, my_answer }
    it { should_not be_able_to :vote_against, voted_question }
    it { should_not be_able_to :vote_against, voted_answer }

    # vote_back
    it { should be_able_to :vote_back, voted_question }
    it { should be_able_to :vote_back, voted_answer }
    it { should_not be_able_to :vote_back, my_question }
    it { should_not be_able_to :vote_back, my_answer }

    # subscribe
    it { should be_able_to :subscribe_on, Question }
    it { should_not be_able_to :subscribe_on, subscribed_question }
    it { should be_able_to :unsubscribe_from, subscribed_question }
    it { should_not be_able_to :unsubscribe_from, question_no_subscribers }

    # API
    it { should be_able_to :me, User }
    it { should be_able_to :all_but_me, User }
  end
end
