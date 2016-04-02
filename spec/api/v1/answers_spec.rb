require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let!(:question) { create(:question_with_file) }
    let(:type) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'unauthorized_request'

    context 'authorized' do
      let(:resource_owner) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: resource_owner.id) }
      let(:question) { create(:question_with_answers) }
      let(:answer) { question.answers.first }
      let(:root_tag) { 'answers' }
      let(:attributes) { %w(id body created_at updated_at) }
      let(:object) { answer }
      let(:json_size) { question.answers.size }

      before { send_request(type, api_path, format: :json, access_token: access_token.token) }

      it_behaves_like 'successful_request'
      it_behaves_like 'index_request'
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question_with_file_attached_to_answer) }
    let(:answer) { question.answers.first }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let(:type) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'unauthorized_request'

    context 'authorized' do
      let(:resource_owner) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: resource_owner.id) }
      let(:root_tag) { 'answer' }
      let(:attributes) { %w(id body created_at updated_at) }
      let(:object) { answer }

      before { send_request(type, api_path, format: :json, access_token: access_token.token) }

      it_behaves_like 'successful_request'
      it_behaves_like 'show request for commentable and attachable object'
    end
  end

  describe '/create' do
    let(:type) { :post }
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    let(:resource_owner) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: resource_owner.id) }
    let(:valid_attributes) { attributes_for(:answer, question: question) }
    let(:invalid_attributes) { attributes_for(:nil_answer) }
    let(:options) { { format: :json, access_token: access_token.token } }
    let(:valid_options) { options.merge(answer: valid_attributes) }
    let(:invalid_options) { options.merge(answer: invalid_attributes) }
    let(:model) { Answer }

    it_behaves_like 'unauthorized_request'
    it_behaves_like 'authorized_create_request'
  end
end
