require 'rails_helper'

feature 'List questions', '
  In order to read questions
  As an guest or user
  I want to browse question list
' do
  given(:user) { create(:user) }
  before do
    create_list :question, 3
    @questions = Question.all
  end
  # given(:questions) { create_list :question, 3 }

  scenario 'Non-authenticated user wants to browse question list' do
    check_question_list(@question)
  end

  scenario 'Authenticated user wants to browse question list' do
    sign_in(user)
    check_question_list(@question)
  end
end
