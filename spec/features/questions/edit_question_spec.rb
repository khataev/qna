require 'features/feature_spec_helpers'

feature 'Edit question', '
  In order to correct mistake
  As an author of the question
  I want to be able to edit my question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:other_user_question) { create(:question) }

  scenario 'Nonauthenticated user does not see Edit question link' do
    visit question_path(question)

    within '.question-area' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Author of question' do
    given(:new_question) { build(:question, title: 'new question title', body: 'new question body') }

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees Edit link, but edit form is hidden', js: true do
      within '.question-area' do
        expect(page).to have_link 'Edit'
        expect(page).to_not have_selector('#edit-question-form')
      end
    end

    scenario 'sees edit form after clicking on Edit link', js: true do
      within '.question-area' do
        click_on 'Edit'

        expect(page).to have_selector('#edit-question-form')
        expect(page).to_not have_link('Edit')
      end
    end

    scenario 'tries to edit his question', js: true do
      within '.question-area' do
        click_on 'Edit'
        fill_in 'Title',  with: new_question.title
        fill_in 'Body',   with: new_question.body
        click_on 'Save'

        expect(page).to have_content new_question.title
        expect(page).to have_content new_question.body
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
      end
    end
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(other_user_question)
    end

    scenario 'does not see Edit link of other user question' do
      within '.question-area' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
