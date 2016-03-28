# Attachments controller
class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  authorize_resource

  def destroy
    @attachment.destroy
    flash[:notice] = 'File has been successfully deleted'
    redirect_to @attachment.attachable if @attachment.attachable_type == 'Question'
    redirect_to @attachment.attachable.question if @attachment.attachable_type == 'Answer'
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
