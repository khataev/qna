# class for Search Model
class Search
  SCOPE_EVERYWHERE  = :Everywhere
  SCOPE_QUESTIONS   = :Questions
  SCOPE_ANSWERS     = :Answers
  SCOPE_COMMENTS    = :Comments
  SCOPE_USERS       = :Users

  SCOPES = {
    Everywhere: ThinkingSphinx,
    Questions:  Question,
    Answers:    Answer,
    Comments:   Comment,
    Users:      User
  }.freeze

  attr_reader :query, :scope

  def initialize(params)
    @query = params[:query]
    @scope = params[:scope].constantize if params[:scope].present?
  end

  def perform_search
    @scope.search(Riddle::Query.escape(@query)) if valid_request?
  end

  private

  def valid_request?
    !@query.blank? && !@scope.blank?
  end
end
