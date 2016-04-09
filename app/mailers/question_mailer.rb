# class for Question Mailer
class QuestionMailer < ApplicationMailer
  def notify_author(answer)
    @answer = answer
    @question = answer.question
    mail to: @question.author.email, subject: "You've got a new answer on MyQnA"
  end

  def notify_subscribers(answer)
    @answer = answer
    @question = answer.question
    @question.subscriptions.find_each do |subscription|
      mail to: subscription.user.email, subject: 'New answers added to question on MyQnA'
    end
  end
end
