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
        expect { post :create, question_id: question, format: :js }.to change(question.subscriptions, :count).by(1)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:question_with_subscriber) { create(:question_with_subscriber, subscriber: user) }

    context 'Non-authenticated user' do
      it 'could not subscribe on question updates' do
        expect { delete :destroy, id: question_with_subscriber.subscriptions.first, format: :js }.to_not change(Subscription, :count)
      end
    end

    context 'Authenticated user' do
      it 'unsubscribes from question updates' do
        sign_in(user)
        expect { delete :destroy, id: question_with_subscriber.subscriptions.find_by(user: user), format: :js }.to change(question_with_subscriber.subscriptions, :count).by(-1)
      end
    end
  end
end
