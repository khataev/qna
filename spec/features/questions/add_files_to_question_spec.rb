require 'features/feature_spec_helpers'

feature 'Add files to Question', '
  In order to illustrate my question
  As an author of question
  I want to attach files
' do
  given(:user) { create(:user) }
  given(:question) { build(:question) }
  given(:question_with_file) { create(:question_with_file, author: user) }

  background do
    sign_in(user)
  end

  scenario 'User has possibility to add or remove file' do
    visit new_question_path
    expect(page).to have_link 'Add file', count: 1
    expect(page).to have_link 'Remove file', count: 1
  end

  scenario 'User adds multiple files when asking question', js: true do
    visit new_question_path
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Add file'

    page.all(:file_field, 'File').first.set("#{Rails.root}/spec/spec_helper.rb")
    page.all(:file_field, 'File').last.set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Post Your Question'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

  scenario 'User can delete attached file' do
    visit question_path(question_with_file)

    cnt = question_with_file.attachments.count

    within '.attachments' do
      expect(page).to have_link 'Delete', count: cnt
    end
  end

  scenario 'User deletes attached file', js: true do
    visit question_path(question_with_file)
    within '.attachments' do
      # binding.pry
      expect(page).to have_link question_with_file.attachments.first.file.filename
      li = first('ul li')
      li.click_link('Delete')

      # a = page.driver.browser.switch_to.alert
      # expect(a.text).to eq("Are you sure?")
      # a.accept

      expect(page).to_not have_link question_with_file.attachments.first.file.filename
    end
  end
end
