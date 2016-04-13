require 'features/sphinx_spec_helpers'

feature 'Sphinx search', '
  As an user
  In order to quickly and easy find data in QnA databse
  I want to be able to perform search queries
' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }
  let!(:comment) { create(:comment, commentable: question) }

  context 'User' do
    before do
      index
      visit root_path
    end

    it 'could search' do
      expect(page).to have_content 'Site search:'
      expect(page).to have_button 'Search'
    end

    it 'searches Everywhere', js: true do
      fill_in :query, with: answer.body
      click_on 'Search'

      expect(page).to have_content 'Search results:'
      expect(page).to have_content answer.body
      expect(page).to have_link answer.question.title
    end

    it 'searches Questions', js: true do
      fill_in :query, with: question.title
      select Search::SCOPE_QUESTIONS, from: :scope
      click_on 'Search'

      expect(page).to have_content 'Search results:'
      expect(page).to have_content question.title
      expect(page).to have_link question.title
    end

    it 'searches Answers', js: true do
      fill_in :query, with: answer.body
      select Search::SCOPE_ANSWERS, from: :scope
      click_on 'Search'

      expect(page).to have_content 'Search results:'
      expect(page).to have_content answer.body
      expect(page).to have_link answer.question.title
    end

    it 'searches Comments', js: true do
      fill_in :query, with: comment.body
      select Search::SCOPE_COMMENTS, from: :scope
      click_on 'Search'

      expect(page).to have_content 'Search results:'
      expect(page).to have_content comment.body
      expect(page).to have_link comment.commentable.title
    end

    it 'searches Users', js: true do
      fill_in :query, with: user.email
      select Search::SCOPE_USERS, from: :scope
      click_on 'Search'

      expect(page).to have_content 'Search results:'
      expect(page).to have_content user.email
    end
  end
end
