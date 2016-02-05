# Helper for Application controller
module ApplicationHelper
  def author_of?(obj)
    if current_user.nil?
      false
    else
      current_user.author_of?(obj)
    end
  end
end
