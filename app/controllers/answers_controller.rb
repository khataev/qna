# Answers controller
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:index, :create]

  def index
    @answers = @question.answers
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user

    flash[:notice] = if @answer.save
                       'Answer successfully created.'
                     else
                       'Incorrect answer data. Try again'
                     end

    redirect_to question_answers_path(@question)
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    @answer.destroy
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
