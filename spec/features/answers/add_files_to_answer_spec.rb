require 'features/feature_spec_helpers'

feature 'Add files to answer', '
  In order to illustrate my answer
  As an author of answer
  I want to attach files
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when answering question', js: true do
    answer = build :answer

    fill_in 'Your answer', with: answer.body
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
