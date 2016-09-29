# Helper for Votable controller
module VotableHelper
  def vote_for_votable_path(votable)
    polymorphic_path(votable, action: 'vote_for')
    # url_for(id: votable, action: 'vote_for')
    # url_for(controller: controller_name, action: 'vote_for', id: votable)
  end

  def vote_against_votable_path(votable)
    polymorphic_path(votable, action: 'vote_against')
  end

  def vote_back_votable_path(votable)
    polymorphic_path(votable, action: 'vote_back')
  end

  def vote_up_icon
    if Rails.env.test?
      'vote_up'
    else
      "<span class='glyphicon glyphicon-triangle-top glyphicon-link'/>".html_safe
    end
  end

  def vote_down_icon
    if Rails.env.test?
      'vote down'
    else
      "<span class='glyphicon glyphicon-triangle-bottom glyphicon-link'/>".html_safe
    end
  end
end
