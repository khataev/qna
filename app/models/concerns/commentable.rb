# Logic for models that could be commented
module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :delete_all, as: :commentable
  end
end
