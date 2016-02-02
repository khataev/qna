require 'rails_helper'

feature 'Question answers', "
  In order to know the answers
  As an authenticated user
  I want to see question's answers
" do
  given(:user) { create(:user) }

  scenario 'Authenticated user wants to see question with answers' do
    question = create :question_with_answers
    sign_in(user)
    visit question_answers_path(question)
    expect(page).to have_content 'Answer'.pluralize(question.answers.count)
    question.answers.each do |a|
      expect(page).to have_content a.body
    end
  end

  scenario 'Authenticated user wants to see question without answers' do
    question = create :question
    sign_in(user)
    visit question_answers_path(question)
    expect(page).to have_content 'Currently no answers yet'
  end

  scenario "Non-authenticated user wants to see question's answers" do
    question = create :question
    visit question_answers_path(question)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user can answer the question' do
    question = create :question
    answer = build :answer
    sign_in(user)
    visit question_answers_path(question)
    fill_in 'Body', with: answer.body
    click_on 'Post Your Answer'
    expect(page).to have_content 'Answer successfully created'
    expect(page).to have_content answer.body
  end
end
