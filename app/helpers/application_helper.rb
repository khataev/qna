# Helper for Application controller
module ApplicationHelper
  def author_of?(obj)
    current_user && current_user.author_of?(obj)
  end
end
