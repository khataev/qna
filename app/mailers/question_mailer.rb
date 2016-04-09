# class for Question Mailer
class QuestionMailer < ApplicationMailer
  def notify_subscriber(user, answer)
    @answer = answer
    @question = answer.question
    mail to: user.email, subject: 'New answers added to question on MyQnA'
  end
end
