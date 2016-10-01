# Helper for Application controller
module ApplicationHelper
  def author_of?(obj)
    current_user && current_user.author_of?(obj)
  end

  def delete_attachment_icon
    if Rails.env.test?
      'Delete'
    else
      "<span class='glyphicon glyphicon-remove'/>".html_safe
    end
  end
end
