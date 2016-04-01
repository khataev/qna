require 'rails_helper'

describe 'Profiles API' do
  describe 'GET /me' do
    let(:api_path) { '/api/v1/profiles/me' }
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get api_path, format: :json
        expect(response).to be_unauthorized
      end

      it 'returns 401 status if there is invalid access token' do
        get api_path, format: :json, access_token: '11111'
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, format: :json, access_token: access_token.token }

      it 'returns 201 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /all_but_me' do
    let(:api_path) { '/api/v1/profiles/all_but_me' }
    context 'unauthorized' do
      it 'returns 401 status if there is no access token' do
        get api_path, format: :json
        expect(response).to be_unauthorized
      end
      it 'returns 401 status if there is invalid token' do
        get api_path, format: :json, access_token: '11111'
        expect(response).to be_unauthorized
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, format: :json, access_token: access_token.token }

      it 'returns 201 status' do
        expect(response).to be_succes
      end

      it 'returns all users except current user' do
        expect(response.body).to_not include_json(me.to_json)
        User.where.not(id: me).each do |user|
          expect(response.body).to include_json(user.to_json)
        end
      end
    end
  end
end
