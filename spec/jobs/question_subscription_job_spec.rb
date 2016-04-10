require 'rails_helper'

RSpec.describe QuestionSubscriptionJob, type: :job do
  let(:question) { create(:question_with_subscribers) }
  let(:answer) { create(:answer, question: question) }

  it 'should send mail to subscribers' do
    question.subscriptions.find_each do |subscription|
      expect(QuestionMailer).to receive(:notify_subscriber).with(subscription.user, answer).and_call_original
    end

    QuestionSubscriptionJob.perform_now(answer)
  end
end
