# class for SubscriptionsController
class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create

  authorize_resource

  respond_to :json

  def create
    @subscription = @question.subscriptions.create(user: current_user)
    render json: @subscription
    # TODO: Why this return empty response?
    # respond_with(@subscription = @question.subscriptions.create(user: current_user))
  end

  private

  def subscription_params
    params.require(:subscription).permit(:user, :question)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
