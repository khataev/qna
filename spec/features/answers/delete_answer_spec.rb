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

  scenario 'Author of a answer deletes it', js: true do
    sign_in(answer_author)
    visit question_path(question)

    expect(page).to have_link('Delete', href: answer_path(answer))

    click_on 'Delete'

    expect(page).to have_content 'Currently no answers yet'
    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(question)
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
