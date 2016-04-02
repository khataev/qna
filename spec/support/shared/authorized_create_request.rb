require 'rails_helper'

RSpec.shared_examples_for 'authorized_create_request' do
  context 'authorized' do
    context 'with valid attributes' do
      it 'returns status 201' do
        send_request(type, api_path, valid_options)
        expect(response).to be_success
      end

      it 'creates question' do
        expect { send_request(type, api_path, valid_options) }.to change(model, :count).by(1)
      end

      it 'returns valid object' do
        send_request(type, api_path, valid_options)
        valid_attributes.each do |key, value|
          expect(response.body).to be_json_eql(value.to_json).at_path("#{model.name.underscore}/#{key}")
        end
      end
    end

    context 'with invalid attributes' do
      it 'returns status 422' do
        send_request(type, api_path, invalid_options)
        expect(response).to be_unprocessable
      end

      it 'does not create object' do
        expect { send_request(type, api_path, invalid_options) }.to_not change(model, :count)
      end
    end
  end
end
