require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #index' do
    let(:question) { create :question }
    let(:answers) { create_list :answer, 5, question: question }
    before { get :index, question_id: question.id }

    it 'populates question answers' do
      expect(assigns(:answers)).to match_array(answers)
    end
  end

  describe 'POST #create' do
    let(:question) { create :question }

    context 'with valid parameters' do
      it 'saves the valid answer in database' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end

      it 'redirects to index view' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_answers_path(question)
      end
    end

    context 'with invalid parameters' do
      it "doesn't save the nil answer in database" do
        expect { post :create, question_id: question.id, answer: attributes_for(:nil_answer) }.to_not change(Answer, :count)
      end

      it 'redirects to index view' do
        post :create, question_id: question.id, answer: attributes_for(:nil_answer)
        expect(response).to redirect_to question_answers_path(question)
      end
    end
  end
end
