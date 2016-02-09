require 'features/feature_helpers'

feature 'Question answers', "
  In order to help the author of the question
  As an authenticated user
  I want to answer the question
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user can answer the question', js: true do
    answer = build :answer

    sign_in(user)
    visit question_path(question)

    expect(page).to have_content 'Post your answer'

    fill_in 'Your answer', with: answer.body
    click_on 'Post Your Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'Authenticated user tries to create invalid answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Post Your Answer'

    expect(page).to have_content "Body can't be blank"
    expect(page).to have_content 'Body is too short (minimum is 10 characters)'
  end
end
