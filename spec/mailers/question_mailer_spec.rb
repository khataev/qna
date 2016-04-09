require 'rails_helper'

RSpec.describe QuestionMailer, type: :mailer do
  describe 'notify_author' do
    let(:user) { create(:user) }
    let(:question) { create(:question_with_answers, author: user) }
    let(:answer) { question.answers.first }
    let(:mail) { QuestionMailer.notify_author(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq("You've got a new answer on MyQnA")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['admin@myqna.com'])
    end
  end
end
