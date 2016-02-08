require 'rails_helper'

feature 'Question answers', "
  In order to help the author of the question
  As an authenticated user
  I want to answer the question
" do
  given(:user) { create(:user) }

  scenario 'Authenticated user can answer the question', js: true do
    question = create :question
    answer = build :answer
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content 'Post your answer'
    fill_in 'Body', with: answer.body
    click_on 'Post Your Answer'
    expect(current_path).to eq question_path(question)
    # TODO: Turned off as have no idea how to do it DRY, because flash contents
    # renders by application.html.haml
    # expect(page).to have_content 'Answer successfully created'
    within '.answers' do
      expect(page).to have_content answer.body
    end
  end
end
