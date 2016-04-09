# class for Application Mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'admin@myqna.com'
  layout 'mailer'
end
