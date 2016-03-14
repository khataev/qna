require_relative 'concerns/votable'
require_relative 'concerns/commentable'

RSpec.describe Question, type: :model do
  # associations
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:delete_all) }
  it { should belong_to(:author) }

  # validations
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:title).is_at_most(100) }
  it { should validate_length_of(:body).is_at_least(10) }

  # nested attributes
  it { should accept_nested_attributes_for :attachments }

  # Votable interface
  it_behaves_like 'votable'

  # Commentable interface
  it_behaves_like 'commentable'
end
