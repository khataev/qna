# Comments controller
class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    @comment = @commentable.comments.create(comment_params)
    @comment.author = current_user
    @comment.save
  end

  private

  def load_commentable
    # TODO: Refactor through commetntable_type param
    @commentable = Question.find(params[:question_id]) if params[:question_id]
    @commentable = Answer.find(params[:answer_id]) if params[:answer_id]
  end

  def comment_params
    params.require(:comment).permit(:body, :mypar)
  end
end
