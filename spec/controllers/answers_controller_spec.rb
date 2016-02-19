require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answered_question) { create(:question_with_answers, author: user) }
  let(:answer) { answered_question.answers.first }
  let(:answer_author) { answer.author }
  let(:some_user) { create(:user) }

  describe 'POST #create' do
    sign_in_user

    let(:question) { create :question }

    context 'with valid parameters' do
      it 'saves the valid answer in database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end

      it 'relate to current user after save' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }.to change(@user.answers, :count).by(1)
      end

      it 'renders template create' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid parameters' do
      sign_in_user

      it "doesn't save the nil answer in database" do
        expect { post :create, question_id: question.id, answer: attributes_for(:nil_answer), format: :js }.to_not change(Answer, :count)
      end

      it 'renders template create' do
        post :create, question_id: question.id, answer: attributes_for(:nil_answer), format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy answer by its author' do
    before do
      sign_in(answer_author)
    end

    it 'deletes the answer' do
      expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question#show view' do
      delete :destroy, id: answer, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'DELETE #destroy answer by someone else' do
    before do
      sign_in(user)
      answer
    end

    it 'could not delete the answer' do
      expect { delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
    end

    it 'redirects to question#show' do
      delete :destroy, id: answer, format: :js
      expect(response).to render_template :destroy
      expect(controller).to set_flash[:notice].to('Only author could delete an answer')
    end
  end

  describe 'PATCH #update' do
    before { sign_in(answer_author) }

    it 'assigns requested answer to @answer' do
      patch :update, id: answer, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns question to @question' do
      patch :update, id: answer, answer: attributes_for(:answer), format: :js
      expect(assigns(:question)).to eq answered_question
    end

    it "changes answer's attributes" do
      patch :update, id: answer, answer: attributes_for(:answer, body: 'new valid body'), format: :js
      answer.reload
      expect(answer.body).to eq 'new valid body'
    end

    it 'renders update template' do
      patch :update, id: answer, answer: attributes_for(:answer), format: :js
      expect(response).to render_template(:update)
    end
  end

  describe 'PATCH #set_best' do
    describe 'As an author of question' do
      before do
        sign_in(user)
        patch :set_best, id: answer, format: :js
      end

      it 'assigns the best answer to @answer' do
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns question to @question' do
        expect(assigns(:question)).to eq answered_question
      end

      it 'makes answer the best' do
        answer.reload
        expect(answer).to be_best
      end

      it 'renders set_best template' do
        expect(response).to render_template :set_best
      end
    end

    describe 'As an non question author' do
      before do
        sign_in(some_user)
        patch :set_best, id: answer, format: :js
      end

      it 'does not make answer the best' do
        answer.reload
        expect(answer).to_not be_best
      end
    end
  end
end
