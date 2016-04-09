require 'rails_helper'

RSpec.describe QuestionSubscriptionJob, type: :job do
  # let(:users) { create_list(:user, 2) }
  let(:question) { create(:question_with_subscribers) }
  let(:answer) { create(:answer, question: question) }

  it 'should send mail to author and subscribers' do
    expect(QuestionMailer).to receive(:notify_subscriber).with(question.author, answer).and_call_original
    question.subscriptions.find_each do |subscription|
      expect(QuestionMailer).to receive(:notify_subscriber).with(subscription.user, answer).and_call_original
    end

    QuestionSubscriptionJob.perform_now(answer)
  end
end
