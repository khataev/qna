require 'rails_helper'

RSpec.shared_examples_for 'voted' do
  let(:controller) { described_class }
  let(:model) { controller.controller_name.singularize }
  let(:votable_sym) { model.to_sym }
  let!(:votable) { create(votable_sym) }
  let(:voter) { create(:user) }

  describe 'PATCH #vote_for votable' do
    context 'As an authenticated user' do
      before { sign_in(voter) }

      it 'assigns instance variable' do
        patch :vote_for, id: votable, format: :json

        expect(assigns(votable_sym)).to eq votable
      end

      it 'increments votable rating' do
        create(:like_vote, votable: votable)

        expect { patch :vote_for, id: votable, format: :json }.to change(votable, :rating).by(1)
      end

      it 'increments votable rating only once per user' do
        create(:like_vote, user: voter, votable: votable)

        expect { patch :vote_for, id: votable, format: :json }.to_not change(votable, :rating)
      end
    end

    context 'As non-authenticated user' do
      it 'could not vote for votable' do
        expect { patch :vote_for, id: votable, format: :json }.to_not change(votable, :rating)
      end
    end
  end

  describe 'PATCH #vote_against votable' do
    context 'As an authenticated user' do
      before { sign_in(voter) }

      it 'assigns instance variable' do
        patch :vote_against, id: votable, format: :json

        expect(assigns(votable_sym)).to eq votable
      end

      it 'decrements votable rating' do
        create(:like_vote, votable: votable)

        expect { patch :vote_against, id: votable, format: :json }.to change(votable, :rating).by(-1)
      end

      it 'decrements votable rating only once per user' do
        create(:like_vote, user: voter, votable: votable)

        expect { patch :vote_against, id: votable, format: :json }.to_not change(votable, :rating)
      end
    end

    context 'As non-authenticated user' do
      it 'could not vote against votable' do
        expect { patch :vote_against, id: votable, format: :json }.to_not change(votable, :rating)
      end
    end
  end
end
