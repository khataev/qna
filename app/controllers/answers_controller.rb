# Answers controller
class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :set_best]
  before_action :build_answer, only: :create

  respond_to :js, only: [:create, :update, :destroy]

  def create
    respond_with(@answer)
  end

  def update
    @question = @answer.question
    respond_with(@answer) do
      flash[:notice] = 'Only author could edit answer' unless current_user.author_of?(@answer) && @answer.update(answer_params)
    end
  end

  def destroy
    @question = @answer.question
    respond_with(@answer) do
      flash[:notice] = 'Only author could delete an answer' unless current_user.author_of?(@answer) && @answer.destroy
    end
  end

  def set_best
    if current_user.author_of?(@answer.question)
      @answer.make_the_best
      @question = @answer.question
      load_answer
    else
      flash[:notice] = 'Only author of question could make answer the best'
    end
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
end
