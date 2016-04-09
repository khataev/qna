# class for QuestionSubscription job
class QuestionSubscriptionJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    @answer = answer
    @question = answer.question

    QuestionMailer.notify_subscriber(@question.author, answer).deliver_later
    @question.subscriptions.find_each do |subscription|
      QuestionMailer.notify_subscriber(subscription.user, answer).deliver_later
    end
  end
end
