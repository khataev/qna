# Questions controller
class QuestionsController < ApplicationController
  include Voted
  include ERB::Util

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      # for question index listeners
      PrivatePub.publish_to '/questions', html: h(render_to_string(@question))
      # for current user
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
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def load_question
    # @question = Question.includes(:attachments, answers: :attachments).find(params[:id])
    @question = Question.find(params[:id])
  end
end
