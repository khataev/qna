require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    context 'Non-authenticated user' do
      it 'could not subscribe on question updates' do
        expect { post :create, question_id: question, format: :js }.to_not change(Subscription, :count)
      end
    end

    context 'Authenticated user' do
      it 'subscribes on question updates' do
        sign_in(user)
        expect { post :create, question_id: question, format: :json }.to change(question.subscriptions, :count).by(1)
      end
    end
  end
end
