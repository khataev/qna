require 'features/feature_spec_helpers'

feature 'Question answers', "
  In order to know the answers
  As an authenticated user
  I want to see question's answers
" do
  given(:user) { create(:user) }

  scenario 'Authenticated user wants to see question with answers' do
    question = create :question_with_answers
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content 'Answer'.pluralize(question.answers.count)
    question.answers.each do |a|
      expect(page).to have_content a.body
    end
  end

  scenario 'Authenticated user wants to see question without answers' do
    question = create :question
    sign_in(user)
    visit question_path(question)
    expect(page).to have_content 'Currently no answers yet'
  end

  scenario "Non-authenticated user wants to see question's answers" do
    question = create :question
    visit question_path(question)
    expect(page).to_not have_content 'Post your answer.'
  end
end
