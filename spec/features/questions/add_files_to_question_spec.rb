require 'features/feature_spec_helpers'

feature 'Add files to Question', '
  In order to illustrate my question
  As an author of question
  I want to attach files
' do
  given(:user) { create(:user) }
  given(:question) { build(:question) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asking question' do
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post Your Question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
