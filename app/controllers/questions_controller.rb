# Questions controller
class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      flash[:notice] = 'Only author could edit a question'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path
    else
      flash[:notice] = 'Only author could delete a question'
      redirect_to question_path(@question)
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
