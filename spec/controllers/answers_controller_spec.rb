require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answered_question) { create(:question_with_answers) }

  describe 'GET #index' do
    sign_in_user

    let(:question) { create :question }
    let(:answers) { create_list :answer, 5, question: question }
    before { get :index, question_id: question.id }

    it 'populates question answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
  end

  describe 'POST #create' do
    sign_in_user

    let(:question) { create :question }

    context 'with valid parameters' do
      it 'saves the valid answer in database' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end

      it 'redirects to index view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_answers_path(question)
      end
    end

    context 'with invalid parameters' do
      sign_in_user

      it "doesn't save the nil answer in database" do
        expect { post :create, question_id: question.id, answer: attributes_for(:nil_answer) }.to_not change(Answer, :count)
      end

      it 'redirects to index view' do
        post :create, question_id: question.id, answer: attributes_for(:nil_answer)
        expect(response).to redirect_to question_answers_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in(user)
    end

    it 'deletes the answer' do
      answer = answered_question.answers.first
      expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
    end

    it "redirects to question's answers" do
      answer = answered_question.answers.first
      q = answer.question
      delete :destroy, id: answer
      expect(response).to redirect_to question_answers_path(q)
    end
  end
end
