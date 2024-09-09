class Messages::Handlers::SendEmail < Messages::Base
  # {
  #   requiest_id: '1',
  #   lat: '123',
  #   lng: '123',
  #   user_name: 'John Doe',
  #   user_id: '1',
  #   contacts: [
  #     {name: 'John Doe', phone: '123-456-7890', email: 'john@doe.com'},
  #     {name: 'Jane Doe', phone: '123-456-7890', email: 'jane@doe.com'}
  #   ]
  # }
  def self.call(params = {request_id: nil, contacts: [], user_id: nil, is_test: false})
    is_test = params[:is_test] || false
    # Prepare the data to be sent
    messages = params.dig(:contacts).map do |contact|
      maps_url = "https://maps.google.com/?q=#{params[:lat]},#{params[:lng]}"
      {
        name: contact.dig(:name),
        message: "Atención #{contact.dig(:name)}. #{params[:user_name]} necesita tu ayuda, contáctale inmediatamente. #{maps_url if params[:lat].present? and params[:lng].present?}",
        destination: contact.dig(:email)
      }
    end
    messages.each do |message|
      response = self.send_email(params[:user_name], message, is_test)
      self.register_message(params[:request_id], message[:message], "email", response, message[:destination], message[:name])
    end

    return true
  end

  def self.send_email(name, message, is_test)
    require "uri"
    require "json"
    require 'base64'
    require "net/http"
    headers = {
      "accept": "application/json",
      'api-key': Rails.application.credentials.email_api_key,
      "content-type": "application/json"
    }
    body = {
      "sender": {
        "name": "Botón de Pánico",
        "email": "panicapp91@gmail.com",
      },
      "to": [
        {
          "email": "#{message[:destination]}",
          "name": "#{message[:name]}"
        }
      ],
      "subject": "#{'[PRUEBA] ' if is_test}Atención #{name} necesita tu ayuda.",
      "htmlContent": "#{message[:message]}"
    }
    url = URI("https://api.brevo.com/v3/smtp/email")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    headers.each do |key, value|
      request[key] = value
    end
    request.body = JSON.dump(body)
    response = https.request(request)
    response = JSON.parse(response.read_body) rescue {}
    puts "-> Email sent to #{message[:destination]} with response #{response}"
    return response
  end

end
