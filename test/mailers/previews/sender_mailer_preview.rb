# Preview all emails at http://localhost:3000/rails/mailers/sender_mailer
class SenderMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/sender_mailer/send_mail
  def send_mail
    SenderMailer.send_mail
  end

end
