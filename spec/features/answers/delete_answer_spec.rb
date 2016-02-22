require 'features/feature_spec_helpers'

feature 'Delete answer', '
  By some reason
  As an authenticated user
  I want to delete answer
' do
  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, author: question_author) }
  given!(:answer) { create(:answer, question: question, author: answer_author) }
  given!(:question_with_answers) { create(:question) }

  describe 'Author' do
    before { sign_in(answer_author) }

    scenario 'of answer should see delete link' do
      visit question_path(question)
      expect(page).to have_link('Delete', href: answer_path(answer))
    end

    scenario 'of the only one answer deletes it', js: true do
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Currently no answers yet'
      expect(page).to_not have_content answer.body
      expect(current_path).to eq question_path(question)
    end

    scenario 'of not the only one answer deletes it', js: true do
      create(:answer, question: question_with_answers, author: answer_author)
      create(:answer, question: question_with_answers)

      visit question_path(question_with_answers)
      cnt = question_with_answers.answers.count
      click_on 'Delete'

      within '#answers-count' do
        expect(page).to have_content("#{cnt - 1} #{'Answer'.pluralize(cnt - 1)}")
      end
      within '.answers-table' do
        expect(page).to_not have_content answer.body
        expect(current_path).to eq question_path(question_with_answers)
      end
    end
  end

  scenario "Authenticated user tries to delete another user's answer" do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link('Delete', href: answer_path(answer))
  end

  scenario "Non-authenticated user tries to delete another user's answer" do
    visit question_path(question)

    expect(page).to_not have_link('Delete', href: answer_path(answer))
  end
end
