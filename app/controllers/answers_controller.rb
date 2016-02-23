# Answers controller
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :set_best]

  def create
    # binding.pry
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
    # binding.pry
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      flash[:notice] = 'Only author could edit answer'
    end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      flash[:notice] = 'Only author could delete an answer'
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
end
