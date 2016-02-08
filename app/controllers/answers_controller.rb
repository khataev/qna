# Answers controller
class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.author = current_user
    flash[:notice] = if @answer.save
                       'Answer successfully created.'
                     else
                       'Incorrect answer data. Try again'
                     end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      flash[:notice] = 'Only author could delete an answer'
    end
    redirect_to question_path(@question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
