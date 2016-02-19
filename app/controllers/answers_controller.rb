# Answers controller
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :set_best]

  def create
    @first_answer = @question.answers.count == 0
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @question = @answer.question
    if current_user.author_of?(@answer)
      @last_question = @question.answers.count == 1
      @answer.destroy
    else
      flash[:notice] = 'Only author could delete an answer'
    end
  end

  def set_best
    return unless current_user.author_of?(@answer.question)
    @answer.make_the_best
    @question = @answer.question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
