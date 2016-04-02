require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    let(:type) { :get }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'unauthorized_request'

    context 'authorized' do
      let(:resource_owner) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: resource_owner.id) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }
      let(:root_tag) { 'questions' }
      let(:attributes) { %w(id title body created_at updated_at) }
      let(:object) { question }
      let(:json_size) { 2 }

      before { send_request(type, api_path, format: :json, access_token: access_token.token) }

      it_behaves_like 'successful_request'
      it_behaves_like 'index_request'

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question_with_file) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let(:type) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'unauthorized_request'

    context 'authorized' do
      let(:resource_owner) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: resource_owner.id) }
      let(:root_tag) { 'question' }
      let(:attributes) { %w(id body created_at updated_at) }
      let(:object) { question }

      before { send_request(type, api_path, format: :json, access_token: access_token.token) }

      it_behaves_like 'successful_request'
      it_behaves_like 'show request for commentable and attachable object'
    end
  end

  describe 'POST /create' do
    let(:type) { :post }
    let(:api_path) { '/api/v1/questions' }

    let(:resource_owner) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: resource_owner.id) }
    let(:valid_attributes) { attributes_for(:question) }
    let(:invalid_attributes) { attributes_for(:question_with_body_less_minimum_size) }
    let(:options) { { format: :json, access_token: access_token.token } }
    let(:valid_options) { options.merge(question: valid_attributes) }
    let(:invalid_options) { options.merge(question: invalid_attributes) }
    let(:model) { Question }

    it_behaves_like 'unauthorized_request'
    it_behaves_like 'authorized_create_request'
  end
end
