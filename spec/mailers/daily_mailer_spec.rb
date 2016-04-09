require 'rails_helper'

RSpec.describe DailyMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { DailyMailer.digest(user) }
    let!(:questions) { create_list(:question, 2, created_at: 1.hours.ago) }

    it 'renders the headers' do
      expect(mail.subject).to eq('MyQnA Daily Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['admin@myqna.com'])
    end
  end
end
