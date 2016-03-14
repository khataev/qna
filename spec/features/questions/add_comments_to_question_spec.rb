require 'features/feature_spec_helpers'

feature 'Commenting question', '
  As an authenticated user
  In order to understand question better
  I want to write comment for question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'Sees Add comment link, but textarea is hidden', js: true do
      within '.question-area' do
        expect(page).to have_link 'Add comment'
        expect(page).to_not have_selector('.new-comment-form')
      end
    end

    scenario 'Sees form for comment after clicking on link', js: true do
      within '.question-area' do
        click_on 'Add comment'

        expect(page).to have_selector('.new-comment-form')
      end
      # expect that click does not affects other commentable objects form
      expect(page).to have_selector('.new-comment-form', count: 1)
    end

    scenario 'Adds comment', js: true do
      comment = build(:comment, author: user)

      within '.question-area' do
        click_on 'Add comment'
        fill_in 'Your Comment', with: comment.body
        click_on 'Post comment'

        within '.comments-area' do
          expect(page).to have_content comment.body
          expect(page).to have_content comment.author.email
          expect(page).to have_content comment.created_at
          expect(current_path).to eq question_path(question)
          expect(page).to_not have_field 'Your Comment'
          expect(page).to have_link 'Add comment'
        end
      end
      # expect comment appeared only once on whole page
      expect(page).to have_content comment.body, count: 1
    end
  end

  describe 'Non-authenticated user' do
    before { visit question_path(question) }

    scenario 'Cannot add comment' do
      within '.question-area' do
        expect(page).to_not have_link 'Add comment'
      end
    end
  end
end
