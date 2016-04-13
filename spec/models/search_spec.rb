require 'rails_helper'

RSpec.describe Search, type: :model do
  it 'includes scope list' do
    expect(Search::SCOPES.keys).to eq %i(Everywhere Questions Answers Comments Users)
  end

  context 'Valid search request' do
    Search::SCOPES.each_pair do |k, v|
      it "performs search by #{k}" do
        params = { query: 'query', scope: v.name }
        search_object = Search.new(params)
        expect(k == Search::SCOPE_EVERYWHERE ? ThinkingSphinx : v).to receive(:search)
        search_object.perform_search
      end
    end
  end

  context 'Invalid search request' do
    let(:params1) { { query: '', scope: Search::SCOPES[Search::SCOPE_QUESTIONS].name } }
    let(:params2) { { query: 'query', scope: '' } }

    it 'does not perform search with empty query' do
      search_object = Search.new(params1)
      expect(Question).to_not receive(:search)
      search_object.perform_search
    end

    it 'does not perform search with empty scope' do
      search_object = Search.new(params2)
      expect(ThinkingSphinx).to_not receive(:search)
      search_object.perform_search
    end
  end
end
