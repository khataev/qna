require 'rails_helper'

feature 'User signs up', '
  In order to be able to ask question
  As an non-registered user
  I want to sign up
' do
  given(:user) { build(:user) }
  given(:wrong_user) { build(:user, password: '1234567890', password_confirmation: '1111111111') }

  scenario 'Non-registered user tries to sign up' do
    sign_up(user)
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign up with wrong password confirmation' do
    # byebug
    # user.password_confirmation.reverse!
    sign_up(wrong_user)
    expect(page).to have_content "Password confirmation doesn't match Password"
    expect(current_path).to eq user_registration_path
  end
end
