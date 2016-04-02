require 'rails_helper'

RSpec.shared_examples_for 'unauthorized_request' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access token' do
      send_request(type, api_path)
      expect(response).to be_unauthorized
    end

    it 'returns 401 status if there is invalid access token' do
      send_request(type, api_path, access_token: '11111')
      expect(response).to be_unauthorized
    end
  end
end
