# Answers controller
class AnswersController < ApplicationController
  before_action :load_question, only: [:index, :create]

  def index
    @answers = @question.answers
  end

  # def new
  #   @answer = @question.answers.new
  # end

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
    else
      # render question_answers_path(@question)
      flash[:notice] = 'Incorrect answer data. Try again'
    end

    redirect_to question_answers_path(@question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
