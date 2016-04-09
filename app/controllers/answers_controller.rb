# Answers controller
class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :set_best]
  before_action :build_answer, only: :create
  after_action  :notify_author, :notify_subscribers, only: :create

  authorize_resource

  respond_to :js, only: [:create, :update, :destroy]

  def create
    respond_with(@answer)
  end

  def update
    @question = @answer.question
    respond_with(@answer.update(answer_params))
  end

  def destroy
    @question = @answer.question
    respond_with(@answer.destroy)
  end

  def set_best
    @question = @answer.question
    @answer.make_the_best
    # load_answer
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    # @answer = Answer.includes(:attachments, question: [answers: :attachments]).find(params[:id])
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def build_answer
    @answer = @question.answers.create(answer_params.merge(author: current_user))
  end

  def notify_author
    QuestionMailer.notify_author(@question.author, @answer).deliver_later unless @answer.id.nil?
  end

  def notify_subscribers
    QuestionMailer.notify_subscribers(@answer).deliver_later unless @answer.id.nil?
  end
end
