class Messages::Handlers::SendSms < Messages::Base
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
  def self.call(params = {request_id: nil})
     # Prepare the data to be sent
     messages = params.dig(:contacts).map do |contact|
      maps_url = "https://maps.google.com/?q=#{params[:lat]},#{params[:lng]}"
      {
        name: contact.dig(:name),
        message: "Atención #{contact.dig(:name)}. #{params[:user_name]} necesita tu ayuda, contáctale inmediatamente. #{maps_url if params[:lat].present? and params[:lng].present?}",
        destination: contact.dig(:phone)
      }
    end
    messages.each do |message|
      response = self.send_sms(message, params[:is_test])
      self.register_message(params[:request_id], message[:message], "sms", response, message[:destination], message[:name])
    end
    return true # TODO return something.
  end

  def self.send_sms(message, is_test)
    require "uri"
    require "json"
    require 'base64'
    require "net/http"

    url = URI("https://api.labsmobile.com/json/send")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Basic " + Base64.strict_encode64(Rails.application.credentials.sms_api_key)
    request.body = JSON.dump({
      "message": "#{'[PRUEBA] ' if is_test}#{message[:message]}",
      "tpoa": "Sender",
      "recipient": [
        {
          "msisdn": message[:destination]
        }
      ]
    })

    # response = OpenStruct.new(read_body: 'ok')
    response = https.request(request)
    response = JSON.parse(response.read_body) rescue {}
    puts "-> SMS sent to #{message.dig(:destination)} with response #{response}"
    return response
  end
end
