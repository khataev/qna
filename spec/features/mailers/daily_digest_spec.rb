require 'features/feature_spec_helpers'

feature 'Send daily digest', '
  As an registered user
  In order to stay in touch
  I want to receive email subscriptions
' do
  given(:user) { create(:user) }
  given!(:old_question) { create(:question, created_at: 25.hours.ago) }
  given!(:new_questions) { create_list(:question, 9) }

  describe 'Daily digest' do
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
end
