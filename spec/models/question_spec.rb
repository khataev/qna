require_relative 'concerns/votable'
require_relative 'concerns/commentable'

RSpec.describe Question, type: :model do
  # associations
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:delete_all) }
  it { should have_many(:subscriptions) }
  it { should belong_to(:author) }

  # validations
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:title).is_at_most(100) }
  it { should validate_length_of(:body).is_at_least(10) }

  # nested attributes
  it { should accept_nested_attributes_for :attachments }

  describe '#user_subscription' do
    let(:user) { create(:user) }
    let(:question_with_subscriber) { create(:question_with_subscriber, subscriber: user) }
    let(:question) { create(:question) }

    it 'returns subscription' do
      subscription = question_with_subscriber.subscriptions.find_by(user: user)
      expect(question_with_subscriber.user_subscription(user)).to eq subscription
    end
    it 'returns nil' do
      expect(question.user_subscription(user)).to be_nil
    end
  end

  describe 'create' do
    it 'should subscribe author after create' do
      new_question = create(:question)
      expect(new_question.subscriptions.first.user).to eq new_question.author
    end
  end

  # Votable interface
  it_behaves_like 'votable'

  # Commentable interface
  it_behaves_like 'commentable'
end
