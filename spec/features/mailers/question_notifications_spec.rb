require 'features/feature_spec_helpers'

feature 'Questions notificatons', '
  In order to stay in touch
  As an registered user
  I want to receive email subscriptions
' do
  describe 'Daily digest' do
    given(:user) { create(:user) }
    given!(:old_question) { create(:question, created_at: 25.hours.ago) }
    given!(:new_questions) { create_list(:question, 9) }

    scenario 'should list questions only created within last 24 hours' do
      clear_emails
      DailyMailer.digest(user).deliver_now
      open_email(user.email)
      new_questions.each do |question|
        expect(current_email).to have_content question.title
      end
      expect(current_email).to_not have_content old_question.title
    end
  end

  describe "Question's author notification" do
    given(:author) { create(:user) }
    given(:user) { create(:user) }
    given!(:question) { create(:question, author: author) }

    scenario 'should call mailer', js: true do
      answer = build :answer

      sign_in(user)
      visit question_path(question)

      fill_in 'Your answer', with: answer.body
      expect(QuestionMailer).to receive(:notify_author).with(author, anything).and_call_original
      click_on 'Post Your Answer'
      sleep(1)
    end

    scenario 'should send new answer notification' do
      clear_emails
      answer = create :answer, question: question

      QuestionMailer.notify_author(author, answer).deliver_now

      open_email(author.email)
      expect(current_email).to have_content 'New answer have been added to your question'
      expect(current_email).to have_content answer.body
      expect(current_email).to have_content question.title
    end
  end
end
