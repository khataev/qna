require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  it 'calls perform_search' do
    search_object = double(Search)
    allow(Search).to receive(:new).and_return(search_object)
    expect(search_object).to receive(:perform_search)
    get :show
  end
end
