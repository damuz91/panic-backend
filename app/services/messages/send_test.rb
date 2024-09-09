class Messages::SendTest < Messages::Base

  def self.call(params)
    user_id = params[:user_id]
    user_name = params[:user_name]
    contacts = [params[:contacts].first]
    user = User.where(store_user_id: user_id).first_or_create
    if user.can_send_messages_today?(true)
      request_id = Messages::Base.register_request(params.merge({is_test: true}))
      Messages::Handlers::SendSms.call(user_name: user_name, contacts: contacts, request_id: request_id, lat: params[:lat], lng: params[:lng], is_test: true)
      Messages::Handlers::SendEmail.call(user_name: user_name, contacts: contacts, request_id: request_id, lat: params[:lat], lng: params[:lng], is_test: true)
      return {response: {success: true, message: "Se han enviado los mensajes a los contactos. Te quedan #{user.max_tests_per_day - user.requests_today.test.count} mensajes por enviar hoy."}, status: :ok}
    else
      return {response: {success: false, message: "Has alcanzado el límite por hoy. Mensajes enviados hoy: #{user.requests_today.test.count}. Intenta de nuevo mañana."}, status: :ok}
    end
  end

end
