# class for SubscriptionsController
class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_subscription, only: :destroy

  authorize_resource

  respond_to :js

  def create
    respond_with(@subscription = @question.subscriptions.create(user: current_user))
  end

  def destroy
    @question = @subscription.question
    respond_with(@subscription.destroy)
  end

  private

  def subscription_params
    params.require(:subscription).permit(:question)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_subscription
    @subscription = Subscription.find(params[:id])
  end
  
end
