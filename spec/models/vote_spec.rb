require 'rails_helper'

RSpec.describe Vote, type: :model do
  # associations
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it 'has scope #user_votes' do
    # users
    user1 = create(:user)
    user2 = create(:user)
    # questions
    question1 = create(:question)
    question2 = create(:question)
    question3 = create(:question)
    # user1 votes
    create(:vote, value: true, user: user1, votable: question1)
    create(:vote, value: false, user: user1, votable: question2)
    create(:vote, value: true, user: user1, votable: question3)
    # user2 votes
    create(:vote, value: true, user: user2, votable: question1)
    create(:vote, value: false, user: user2, votable: question2)
    # expectations
    expect(Vote.user_votes(user1).count).to eq 3
    expect(Vote.user_votes(user2).count).to eq 2
  end
end
