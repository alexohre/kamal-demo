class PagesController < ApplicationController
  include HTTParty
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

  def send_sms
    phone_number = params[:phone_number].strip
    message = params[:message]

    response = send_sms_via_termii(phone_number, message)
   
    if response['code'] == 'ok'
      flash[:notice] = "SMS sent successfully!"
    else
      flash[:alert] = "Failed to send SMS: #{response['message']}"
    end

    redirect_to sms_path # Redirect to the desired path after sending the SMS
  end

  private

  def send_sms_via_termii(phone_number, message)
    options = {
      body: {
        to: phone_number, # Wrap the phone number in an array
        from: "fastBeep",
        sms: message,
        type: "plain", # or "flash"
        channel: "generic", # or "dnd" for Do Not Disturb
        api_key: Rails.application.credentials.fetch(:termii)[:api_key]
      }.to_json,
      headers: {
        'Content-Type' => 'application/json'
      }
    }

    # Rails.logger.info "Termii API Key: #{ENV['TERMII_API_KEY']}"

    begin
      # Log request body for verification
      Rails.logger.info "Request Body: #{options[:body]}"

      response = HTTParty.post("https://api.ng.termii.com/api/sms/send", options)

      # Log the response for debugging
      Rails.logger.info "Termii Response Code: #{response.code}"
      Rails.logger.info "Termii Response Body: #{response.body}"
      Rails.logger.info "Termii Response Headers: #{response.headers.inspect}"

      parsed_response = JSON.parse(response.body) rescue nil

      if parsed_response.nil? || parsed_response.empty?
        Rails.logger.error "Empty or invalid JSON response from Termii"
        return { 'message' => 'Empty or invalid response from Termii' }
      end

      parsed_response

    rescue => e
      Rails.logger.error "Error sending SMS via Termii: #{e.message}"
      { 'message' => 'Failed to send SMS due to an internal error' }
    end

    # response = HTTParty.post("https://api.ng.termii.com/api/sms/number/send", options)

    # # Log the response for debugging
    # Rails.logger.info "Termii Response Code: #{response.code}"
    # Rails.logger.info "Termii Response Body: #{response.body}"

    # # Parse the JSON response only if the body is not empty
    # JSON.parse(response.body) unless response.body.blank?
  end

  # def send_sms_via_termii(phone_number, message)
  #   uri = URI.parse("https://api.ng.termii.com/api/sms/send")

  #   http = Net::HTTP.new(uri.host, uri.port)
  #   http.use_ssl = true

  #   request = Net::HTTP::Post.new(uri.path, { 'Content-Type': 'application/json' })
  #   request.body = {
  #     to: phone_number,
  #     from: "YourSenderID",
  #     sms: message,
  #     type: "plain", # or "flash"
  #     channel: "generic", # or "dnd" for Do Not Disturb
  #     api_key: ENV['TERMII_API_KEY']
  #   }.to_json

  #   response = http.request(request)
  #   JSON.parse(response.body)
  # end

end
