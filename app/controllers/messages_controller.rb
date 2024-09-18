class MessagesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :check_api_key

  # POST /send_sos
  # {
  #   os: 'ios',
  #   user_id: '1',
  #   user_name: 'John Doe',
  #   contacts: [
  #     {name: 'John Doe', phone: '123-456-7890', email: 'john@doe.com'},
  #     {name: 'Jane Doe', phone: '123-456-7890', email: 'jane@doe.com'}
  #   ]
  # }
  def send_sos
    request = Messages::SendSos.call(params)
    render json: request[:response], status: request[:status]
  end

  # POST /send_test
  # {
  #   os: 'ios',
  #   user_id: '1',
  #   user_name: 'John Doe',
  #   contacts: [
  #     {name: 'John Doe', phone: '123-456-7890', email: 'john@doe.com'},
  #   ]
  # }
  def send_test
    request = Messages::SendTest.call(params)
    render json: request[:response], status: request[:status]
  end

  private
  def check_api_key
    if request.headers['Authorization'] != ENV['API_KEY_HEADER']
      puts "API KEY: #{request.headers['Authorization']}"
      puts "ENV API KEY: #{ENV['API_KEY_HEADER']}"
      render json: {message: 'No estas autorizado para realizar esta acción'}, status: 403
      return
    end
  end

end
