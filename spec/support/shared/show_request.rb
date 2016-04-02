require 'rails_helper'

RSpec.shared_examples_for 'show request for commentable and attachable object' do
  context 'comments' do
    it 'includes comments' do
      expect(response.body).to have_json_size(object.comments.size).at_path("#{root_tag}/comments")
    end

    it 'contains attributes' do
      attributes.each do |attr|
        expect(response.body).to be_json_eql(object.comments.first.send(attr.to_sym).to_json).at_path("#{root_tag}/comments/0/#{attr}")
      end
    end
  end

  context 'attachments' do
    it 'includes attachments' do
      expect(response.body).to have_json_size(object.attachments.size).at_path("#{root_tag}/attachments")
    end
    %w(id created_at).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(object.attachments.first.send(attr.to_sym).to_json).at_path("#{root_tag}/attachments/0/#{attr}")
      end
    end

    it 'contains url' do
      expect(response.body).to be_json_eql(object.attachments.first.file.url.to_json).at_path("#{root_tag}/attachments/0/url")
    end
  end
end
