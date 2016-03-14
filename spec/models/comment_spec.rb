require 'rails_helper'

RSpec.describe Comment, type: :model do
  # associations
  it { should belong_to :author }
  it { should belong_to :commentable }

  # validations
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:body).is_at_least(10).is_at_most(100) }
end
