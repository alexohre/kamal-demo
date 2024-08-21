class SenderMailer < ApplicationMailer
default from: 'NoReply <no-reply@mail.softalx.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  def send_mail(to, subject, content)
   @content = content
    mail(to: to, subject: subject)
  end
end
