# class for SearchController
class SearchController < ApplicationController
  before_action :create_search_object, only: :show

  authorize_resource

  def show
    @search_results = @search_object.perform_search
  end

  private

  def create_search_object
    @search_object = Search.new(params)
  end
end
