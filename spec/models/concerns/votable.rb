require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let!(:first_user) { create(:user) }
  let!(:second_user) { create(:user) }
  let!(:author) { create(:user) }
  let(:model) { described_class }
  let!(:votable) { create(model.to_s.underscore.to_sym, author: author) }

  # associations
  it { should have_many(:votes) }

  # behaviour
  describe 'Rating' do
    it 'counts rating 0' do
      create_list(:vote, 3, votable: votable, value: true)
      create_list(:vote, 3, votable: votable, value: false)

      expect(votable.rating).to eq 0
    end

    it 'counts rating 1' do
      create_list(:vote, 3, votable: votable, value: true)
      create_list(:vote, 2, votable: votable, value: false)

      expect(votable.rating).to eq 1
    end

    it 'counts rating -1' do
      create_list(:vote, 2, votable: votable, value: true)
      create_list(:vote, 3, votable: votable, value: false)

      expect(votable.rating).to eq(-1)
    end
  end

  describe 'Voting' do
    it 'associates vote with user' do
      votable.vote_for(first_user)
      expect(votable.votes.first.user).to eq first_user
    end

    it 'increments rating after vote for' do
      expect { votable.vote_for(first_user) }.to change(votable, :rating).by(1)
    end

    it 'decrements rating after vote against' do
      expect { votable.vote_against(first_user)  }.to change(votable, :rating).by(-1)
    end
  end

  describe 'Voting for owned votable' do
    it 'is not possible to vote for' do
      expect { votable.vote_for(author) }.to_not change(votable, :rating)
    end
    it 'is not possible to vote against' do
      expect { votable.vote_against(author) }.to_not change(votable, :rating)
    end
  end

  describe 'Vote cancelling' do
    it 'cancels vote for' do
      votable.vote_for(first_user)
      expect { votable.vote_back(first_user) }.to change(votable, :rating).by(-1)
    end

    it 'cancels vote against' do
      votable.vote_against(first_user)
      expect { votable.vote_back(first_user) }.to change(votable, :rating).by(1)
    end
  end

  describe 'voted_by? method' do
    it 'returns true' do
      votable.vote_for(first_user)
      expect(votable.voted_by?(first_user)).to eq true
    end

    it 'returns false' do
      votable.vote_for(first_user)
      expect(votable.voted_by?(second_user)).to eq false
    end
  end
end
