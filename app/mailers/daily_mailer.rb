# class for Daily Mailer
class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.last_day_questions
    mail to: user.email, subject: 'MyQnA Daily Digest'
  end
end
