# Voted Concern for Controllers
module Voted
  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:vote_for, :vote_against, :vote_back]
  end

  def vote_for
    respond_to do |format|
      if votable_variable.vote_for(current_user)
        format.json { render json: votable_variable }
      else
        format.json { render json: votable_variable.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def vote_against
    respond_to do |format|
      if votable_variable.vote_against(current_user)
        format.json { render json: votable_variable }
      else
        format.json { render json: votable_variable.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def vote_back
    respond_to do |format|
      votable_variable.vote_back(current_user)
      format.json { render json: votable_variable }
    end
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
