class PagesController < ApplicationController
  def home
  end

  def sms
  end

  def email
  end

  def send_email
    to = params[:to]
    subject = params[:subject]
    content = params[:content]

    # Call the mailer to send the email
    SenderMailer.send_mail(to, subject, content).deliver_later

    flash[:notice] = "Email sent successfully!"
    redirect_to email_path # Redirect to the desired path after sending the email
  end
end
