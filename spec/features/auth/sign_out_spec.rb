require 'rails_helper'

feature 'User signs out', '
  In order to sign out the system
  As an authenticated user
  I want to sign out
' do
  given(:user) { create(:user) }

  scenario 'Authenticated user tries to sign out' do
    sign_in(user)

    click_on 'Logout'
    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end
