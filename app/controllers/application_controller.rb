require 'application_responder'

# Application controller
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  check_authorization unless: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        subject = exception.subject
        action = exception.action
        if subject.is_a?(Question) && action == :destroy
          redirect_to question_path(subject), notice: exception.message
        else
          redirect_to root_path, notice: exception.message
        end
      end
      format.json { render json: { errors: exception.message }, status: :unprocessable_entity }
      format.js do
        flash[:notice] = exception.message
        render status: :unprocessable_entity
      end
    end
  end
end
