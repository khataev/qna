# Questions controller
class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :destroy, :update]
  before_action :build_answer, only: :show
  after_action  :publish_question, only: :create

  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = Question.new)
  end

  def show
    respond_with @question
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    respond_with(@question) do
      flash[:notice] = 'Only author could edit a question' unless current_user.author_of?(@question) && @question.update(question_params)
    end
  end

  def destroy
    respond_with(@question) do
      flash[:notice] = 'Only author could delete a question' unless current_user.author_of?(@question) && @question.destroy
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

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    PrivatePub.publish_to('/questions', question: @question.to_json) if @question.valid?
  end
end
