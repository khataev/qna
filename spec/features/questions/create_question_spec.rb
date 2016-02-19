require 'features/feature_spec_helpers'

feature 'Create question', '
  In order to get answer
  As an authenticated user
  I want to create question
' do
  given(:user) { create(:user) }
  given(:question) { build(:question) }

  scenario 'Authenticated user creates question' do
    sign_in(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Post Your Question'

    expect(page).to have_content 'Your question successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Unauthenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
