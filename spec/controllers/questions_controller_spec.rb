require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list :question, 3 }
    before { get :index }

    it 'populates an array of questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template(:new)
    end

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe 'GET #show' do
    sign_in_user

    let!(:question) { create(:question) }
    let!(:answers) { create_list :answer, 1, question: question }

    before { get :show, id: question.id }

    it 'populates question answers' do
      expect(assigns(:answers)).to match_array(question.answers)
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the valid question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'saved question is associated with user' do
        post :create, question: attributes_for(:question)
        expect(Question.first.user_id).to eq(@user.id)
      end

      it 'redirects to show answers' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid parameters' do
      it "doesn't save the nil question in database" do
        expect { post :create, question: attributes_for(:nil_question) }.to_not change(Question, :count)
      end

      it "doesn't save the question with body less than minimum length in database" do
        expect { post :create, question: attributes_for(:question_with_body_less_minimum_size) }.to_not change(Question, :count)
      end

      it "doesn't save the question with title more than maximum length in database" do
        expect { post :create, question: attributes_for(:question_with_title_more_maximum_size) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:nil_question)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy question by its author' do
    let(:question) { create(:question) }

    before do
      sign_in(question.author)
    end

    it 'deletes the question' do
      expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
    end

    it 'deletes related answers' do
      delete :destroy, id: question
      expect(Answer.count(question_id: question.id)).to eq 0
    end

    it 'redirects to #index page' do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end

  describe 'DELETE #destroy question by someone else' do
    let(:question) { create(:question) }

    before do
      sign_in(user)
      question
    end

    it 'could not delete the question' do
      expect { delete :destroy, id: question }.to_not change(Question, :count)
    end

    it 'redirects to #index page' do
      delete :destroy, id: question
      expect(response).to redirect_to question_path(question)
      expect(controller).to set_flash[:notice].to('Only author could delete a question')
    end
  end
end
