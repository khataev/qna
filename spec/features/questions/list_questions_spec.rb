require 'features/feature_helpers'

feature 'List questions', '
  In order to read questions
  As an guest or user
  I want to browse question list
' do
  given(:user) { create(:user) }
  given!(:questions) { create_list :question, 3 }

  scenario 'Non-authenticated user wants to browse question list' do
    check_question_list(questions)
  end

  scenario 'Authenticated user wants to browse question list' do
    sign_in(user)
    check_question_list(questions)
  end
end
