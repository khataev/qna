require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    describe 'by authenticated user' do
      before { sign_in(user) }
      context 'with valid parameters' do
        it 'adds comment to question' do
          expect { post :create, comment: attributes_for(:comment), question_id: question, format: :js }.to change(question.comments, :count).by(1)
        end

        it 'associates comment with current user' do
          post :create, comment: attributes_for(:comment), question_id: question, format: :js
          expect(question.comments.first.author.id).to eq user.id
        end

        it 'renders create template' do
          post :create, comment: attributes_for(:comment), question_id: question, format: :js
          expect(response).to render_template(:create)
        end
      end

      context 'with invalid parameters' do
        it 'could not add comment to question' do
          expect { post :create, comment: attributes_for(:comment_with_nil_body), question_id: question, format: :js }.to_not change(Comment, :count)
        end

        it 'renders create template' do
          post :create, comment: attributes_for(:comment), question_id: question, format: :js
          expect(response).to render_template(:create)
        end
      end
    end

    describe 'by someone else' do
      it 'could not add comment to question' do
        expect { post :create, comment: attributes_for(:comment), question_id: question, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
