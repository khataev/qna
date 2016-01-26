require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
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
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template(:new)
    end

    it 'assigns new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the valid question in database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirects to show answers' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_answers_path(assigns(:question))
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
end
