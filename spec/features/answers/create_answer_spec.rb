require 'rails_helper'

feature 'Question answers', "
  In order to help the author of the question
  As an authenticated user
  I want to answer the question
" do
  given(:user) { create(:user) }

  scenario 'Authenticated user can answer the question' do
    question = create :question
    answer = build :answer
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content 'Post your answer'
    fill_in 'Body', with: answer.body
    click_on 'Post Your Answer'
    expect(page).to have_content 'Answer successfully created'
    expect(page).to have_content answer.body
  end
end
