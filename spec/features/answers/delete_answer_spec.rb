require 'rails_helper'

feature 'Delete answer', '
  By some reason
  As an authenticated user
  I want to delete answer
' do
  given(:question_author) { create(:user, password: '1111111111', password_confirmation: '1111111111') }
  given(:answer_author) { create(:user, password: '2222222222', password_confirmation: '2222222222') }
  given(:another_user) { create(:user, password: '333333333', password_confirmation: '333333333') }
  given(:question) { create(:question, author: question_author) }
  given(:answer) { create(:answer, question: question, author: answer_author) }

  before do
    answer
    question.reload
  end

  scenario 'Author of a answer deletes it' do
    sign_in(answer_author)
    visit question_answers_path(question)
    expect(page).to have_link('Delete Answer', href: answer_path(answer))
    click_on 'Delete Answer'
    expect(page).to have_content 'Currently no answers yet'
    expect(current_path).to eq question_answers_path(question)
  end

  scenario "Authenticated user tries to delete another user's answer" do
    sign_in(another_user)
    visit question_answers_path(question)
    expect(page).to_not have_link('Delete Answer', href: answer_path(answer))
  end
end
