# Voted Concern for Controllers
module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_for, :vote_against, :vote_back]
  end

  def vote_for
    votable_variable.vote_for(current_user)
    render json: votable_variable
  end

  def vote_against
    votable_variable.vote_against(current_user)
    render json: votable_variable
  end

  def vote_back
    votable_variable.vote_back(current_user)
    render json: votable_variable
  end

  private

  def votable_variable
    instance_variable_get("@#{controller_name.singularize}")
  end

  def model_klass
    controller_name.classify.constantize
  end

  def load_votable
    instance_variable_set("@#{controller_name.singularize}", model_klass.find(params[:id]))
  end
end
