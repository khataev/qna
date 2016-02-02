module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def sign_up(user)
    visit new_user_session_path
    click_on 'Register'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'
  end

  def check_question_list(_questions)
    visit questions_path
    expect(page).to have_content(@questions.first.title)
    expect(page).to have_content(@questions.last.title)
  end
end
