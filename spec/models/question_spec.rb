require 'rails_helper'

RSpec.describe Question, type: :model do
  # associations
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author) }

  # validations
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :author }
  it { should validate_length_of(:title).is_at_most(100) }
  it { should validate_length_of(:body).is_at_least(10) }
end
