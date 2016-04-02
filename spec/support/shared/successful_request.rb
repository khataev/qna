require 'rails_helper'

RSpec.shared_examples_for 'successful_request' do
  it 'returns 201 status' do
    expect(response).to be_success
  end
end
