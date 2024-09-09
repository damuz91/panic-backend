class Messages::SendSos < Messages::Base

  def self.call(params)
    user_id = params[:user_id]
    user_name = params[:user_name]
    contacts = params[:contacts]
    user = User.where(store_user_id: user_id).first_or_create
    if user.can_send_messages_today?(false)
      request_id = Messages::Base.register_request(params.merge({is_test: false}))
      Messages::Handlers::SendSms.call(user_name: user_name, contacts: contacts, request_id: request_id, lat: params[:lat], lng: params[:lng])
      Messages::Handlers::SendEmail.call(user_name: user_name, contacts: contacts, request_id: request_id, lat: params[:lat], lng: params[:lng])
      # Messages::Handlers::SendCall.call(user_name: user_name, contacts: contacts, request_id: request_id, lat: params[:lat], lng: params[:lng])
      return {response: {success: true, message: "Se han enviado los mensajes a los contactos. Te quedan #{user.max_sos_per_day - user.requests_today.sos.count} mensajes por enviar hoy."}, status: :ok}
    else
      return {response: {success: false, message: "Has alcanzado el límite por hoy. Mensajes enviados hoy: #{user.requests_today.sos.count}. Intenta de nuevo mañana."}, status: :ok}
    end
  end

end
