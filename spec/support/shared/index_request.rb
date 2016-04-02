require 'rails_helper'

RSpec.shared_examples_for 'index_request' do
  it 'returns list of objects' do
    expect(response.body).to have_json_size(json_size).at_path(root_tag.to_s)
  end

  it 'contains attributes' do
    attributes.each do |attr|
      expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path("#{root_tag}/0/#{attr}")
    end
  end
end
