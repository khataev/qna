# Model for Authorization
class Authorization < ActiveRecord::Base
  belongs_to :user
end
