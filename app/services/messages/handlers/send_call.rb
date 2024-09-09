class Messages::Handlers::SendCall < Messages::Base

  def self.call(params = {request_id: nil, contacts: [], user_id: nil})

    # Prepare the data to be sent
    messages = params.dig(:contacts).map do |contact|
      {
        name: contact.dig(:name),
        message: "Atención #{contact.dig(:name)}. #{params[:user_name]} necesita tu ayuda, contáctale inmediatamente.",
        destination: contact.dig(:phone)
      }
    end

    messages.each do |message|

      # Logic to send phone call here

      response = OpenStruct.new(read_body: 'ok')
      puts "-> SMS sent to #{message.dig(:destination)} with response #{response.read_body}"
      self.register_message(params[:request_id], message[:message], "phone", "sent", message[:destination], message[:name])
    end

    return true
  end
end
