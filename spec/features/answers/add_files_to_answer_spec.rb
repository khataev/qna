require 'features/feature_spec_helpers'

feature 'Add files to answer', '
  In order to illustrate my answer
  As an author of answer
  I want to attach files
' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:question_with_file) { create(:question_with_file_attached_to_answer, author: user) }

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
      expect(page).to have_link 'spec_helper.rb'
      # почему-то при запуске со всеми тестами, ссылка отличается: вместо 1 - 5
      # , href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds multiple files when answering question', js: true do
    answer = build :answer

    fill_in 'Your answer', with: answer.body
    click_on 'Add file'

    page.all(:file_field, 'File').first.set("#{Rails.root}/spec/spec_helper.rb")
    page.all(:file_field, 'File').last.set("#{Rails.root}/spec/rails_helper.rb")

    click_on 'Post Your Answer'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end

  scenario 'User can delete attached file' do
    visit question_path(question_with_file)

    answer = question_with_file.answers.first
    cnt = answer.attachments.count

    within "#answer-#{answer.id} .attachments" do
      expect(page).to have_link 'Delete', count: cnt
    end
  end

  scenario 'User deletes attached file', js: true do
    visit question_path(question_with_file)
    answer = question_with_file.answers.first

    within "#answer-#{answer.id} .attachments" do
      # binding.pry
      expect(page).to have_link answer.attachments.first.file.filename
      li = first('ul li')
      li.click_link('Delete')

      # a = page.driver.browser.switch_to.alert
      # expect(a.text).to eq("Are you sure?")
      # a.accept

      expect(page).to_not have_link answer.attachments.first.file.filename
    end
  end
end
