require 'features/feature_spec_helpers'

feature 'Questions notificatons', '
  In order to stay in touch
  As an registered user
  I want to receive email subscriptions
' do
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
  end

  describe "Question's subscribers notifier" do
    given(:user) { create(:user) }
    given(:question_no_subscibers) { create(:question) }
    given!(:question) { create(:subscribed_question, subscriber: user) }
    given!(:answer) { create(:answer, question: question) }

    scenario 'should call mailer', js: true do
      answer = build :answer

      sign_in(user)
      visit question_path(question)

      fill_in 'Your answer', with: answer.body
      expect(QuestionMailer).to receive(:notify_subscribers).and_call_original
      click_on 'Post Your Answer'
      sleep(1)
    end

    scenario 'should send no email if question has no subscribers', js: true do
      clear_emails
      answer = build :answer

      sign_in(user)
      visit question_path(question_no_subscibers)

      fill_in 'Your answer', with: answer.body
      expect(QuestionMailer).to receive(:notify_subscribers).and_call_original
      click_on 'Post Your Answer'
      sleep(1)
      expect(current_email).to be_nil
    end
  end
end
