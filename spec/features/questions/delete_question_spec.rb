require 'rails_helper'

feature 'Delete question', '
  By some reason
  As an authenticated user
  I want to delete question
' do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Author of a question deletes it' do
    sign_in(question.author)
    visit question_answers_path(question)
    expect(page).to have_link('Delete', href: question_path(question))
  end

  scenario "Authenticated user tries to delete another user's question" do
    sign_in(user)
    visit question_answers_path(question)
    expect(page).to_not have_link('Delete', href: question_path(question))
  end
end
