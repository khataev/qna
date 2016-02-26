# Attachments controller
class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  def destroy
    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
      flash[:notice] = 'File has been successfully deleted'
    else
      flash[:notice] = 'Only object author could delete its file'
    end
    redirect_to @attachment.attachable if @attachment.attachable_type == 'Question'
    redirect_to @attachment.attachable.question if @attachment.attachable_type == 'Answer'
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
