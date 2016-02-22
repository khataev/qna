require 'features/feature_spec_helpers'

feature 'Edit answer', '
  In order to correct mistake
  As an author of answer
  I want to be able to edit my answer
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:other_user_answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link('Edit')
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees link Edit of his answer', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to have_link('Edit')
        expect(page).to_not have_selector('textarea#answer_body')
      end
    end

    scenario 'sees edit answer textarea with answer current value', js: true do
      within '.answers-table' do
        click_on 'Edit'
      end

      within "form#edit-answer-#{answer.id}" do
        expect(page).to have_selector('textarea')
      end
    end

    scenario 'does not see Edit link after click on it', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        expect(page).to_not have_link('Edit')
      end
    end

    scenario 'tries to edit his answer', js: true do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        within '.answer_body' do
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_content answer.body
        end

        expect(page).not_to have_selector 'textarea#answer_body'
      end

      within '.answers-table' do
        expect(page).to have_selector("#answer-#{answer.id}", count: 1)
      end
    end

    scenario 'tries to edit another user answer', js: true do
      within "#answer-#{other_user_answer.id}" do
        expect(page).to_not have_link('Edit')
        expect(page).to_not have_selector('textarea')
      end
    end
  end
end
