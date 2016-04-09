require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe '#digest' do
    let(:user) { create(:user) }
    let(:mail) { DailyMailer.digest(user) }
    let!(:old_question) { create(:question, created_at: 25.hours.ago) }
    let!(:new_questions) { create_list(:question, 9) }

    it 'renders the headers' do
      expect(mail.subject).to eq('MyQnA Daily Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['admin@myqna.com'])
    end

    it 'should list questions only created within last 24 hours' do
      new_questions.each do |question|
        expect(mail.body).to have_content question.title
      end
      expect(mail.body).to_not have_content old_question.title
    end
  end
end
