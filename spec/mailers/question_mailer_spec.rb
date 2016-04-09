require 'rails_helper'

RSpec.describe QuestionMailer, type: :mailer do
  describe '#notify_author' do
    let(:user) { create(:user) }
    let(:question) { create(:question_with_answers, author: user) }
    let(:answer) { question.answers.first }
    let(:mail) { QuestionMailer.notify_author(answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq("You've got a new answer on MyQnA")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['admin@myqna.com'])
    end

    it 'contains question title and new answer' do
      expect(mail.body).to have_content 'New answer have been added to your question'
      expect(mail.body).to have_content answer.body
      expect(mail.body).to have_content question.title
    end
  end

  describe '#notify_subscribers' do
    let(:user) { create(:user) }
    let!(:question) { create(:subscribed_question, subscriber: user) }
    let!(:answer) { create(:answer, question: question) }
    let(:mail) { QuestionMailer.notify_subscribers(answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answers added to question on MyQnA')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['admin@myqna.com'])
    end

    it 'contains question title and new answer' do
      expect(mail.body).to have_content question.title
      expect(mail.body).to have_content answer.body
    end
  end
end
