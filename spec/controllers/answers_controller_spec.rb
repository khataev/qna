require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answered_question) { create(:question_with_answers) }
  let(:answer) { answered_question.answers.first }
  let(:answer_author) { answer.author }

  describe 'POST #create' do
    sign_in_user

    let(:question) { create :question }

    context 'with valid parameters' do
      it 'saves the valid answer in database' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question#show view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid parameters' do
      sign_in_user

      it "doesn't save the nil answer in database" do
        expect { post :create, question_id: question.id, answer: attributes_for(:nil_answer) }.to_not change(Answer, :count)
      end

      it 'redirects to show view' do
        post :create, question_id: question.id, answer: attributes_for(:nil_answer)
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy answer by its author' do
    before do
      sign_in(answer_author)
    end

    it 'deletes the answer' do
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question#show view' do
      q = answer.question
      delete :destroy, id: answer
      expect(response).to redirect_to question_path(q)
    end
  end

  describe 'DELETE #destroy answer by someone else' do
    before do
      sign_in(user)
      answer
    end

    it 'could not delete the answer' do
      expect { delete :destroy, id: answer }.to_not change(Answer, :count)
    end

    it 'redirects to question#show' do
      q = answer.question
      delete :destroy, id: answer
      expect(response).to redirect_to question_path(q)
      expect(controller).to set_flash[:notice].to('Only author could delete an answer')
    end
  end
end
