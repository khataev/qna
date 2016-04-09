# class for Question Mailer
class QuestionMailer < ApplicationMailer
  def notify_author(user, answer)
    @answer = answer
    @question = answer.question
    mail to: user.email, subject: "You've got a new answer on MyQnA"
  end
end
