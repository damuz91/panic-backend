class Messages::Base

  def self.register_request(params = {user_id: nil, user_name: nil, os: nil, is_test: false})
    user = User.where(store_user_id: params[:user_id]).first
    if user.nil?
      user = User.create(store_user_id: params[:user_id], name: params[:user_name])
    else
      user.update(name: params[:user_name]) if user.name != params[:user_name]
    end
    request = Request.create(user_id: user.id, os: params[:os], request_type: params[:is_test] ? "test" : "sos")
    return request.id
  end

  def self.register_message(request_id, message, message_type, status, destination, name)
    Message.create(request_id: request_id, message: message, message_type: message_type, status: status, destination: destination, name: name)
  end
end
