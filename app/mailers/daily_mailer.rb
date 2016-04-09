# class for Daily Mailer
class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('created_at >= ? ', 24.hours.ago)
    mail to: user.email, subject: 'MyQnA Daily Digest'
  end
end
