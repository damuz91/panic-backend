class User < ApplicationRecord
  has_many :requests
  has_many :messages, through: :requests

  MAX_TESTS_PER_DAY = 2
  MAX_SOS_PER_DAY = 3

  MAX_TESTS_PER_DAY_PREMIUM = 5
  MAX_SOS_PER_DAY_PREMIUM = 5

  def general_report
    puts "-------------------------"
    puts "-> Report for #{self.store_user_id} -> #{self.name}"
    puts "-> Requests: #{self.requests.count}"
    puts "-> Messages: #{self.messages.count}"
    puts "-------------------------"
  end

  def last_request_report
    puts "-------------------------"
    puts "-> Last request for #{self.store_user_id} -> #{self.name}"
    request = self.requests.last
    puts "-> Request ID: #{request.id}"
    puts "-> OS: #{request.os}"
    puts "-> Created at: #{request.created_at}"
    puts "-> Messages: #{request.messages.count}"
    puts "-> Messages list:"
    request.messages.each do |message|
      puts "  -> Message ID: #{message.id}"
      puts "  -> Message: #{message.message}"
      puts "  -> Message type: #{message.message_type}"
      puts "  -> Status: #{message.status}"
      puts "  -> Destination: #{message.destination}"
      puts "  -> Name: #{message.name}"
      puts "  -> Created at: #{message.created_at}"
      puts "  <<-----------------------"
    end
    puts "-------------------------"
  end

  # If the user is premium, use the premium limits
  # If it is a test, use the test limits
  def can_send_messages_today?(is_test)
    if is_test
      return self.requests_today.test.count < self.max_tests_per_day
    else
      return self.requests_today.sos.count < self.max_sos_per_day
    end
  end

  def max_tests_per_day
    self.is_premium ? MAX_TESTS_PER_DAY_PREMIUM : MAX_TESTS_PER_DAY
  end

  def max_sos_per_day
    self.is_premium ? MAX_SOS_PER_DAY_PREMIUM : MAX_SOS_PER_DAY
  end

  def requests_today
    return self.requests.where("created_at >= ?", Time.zone.now.beginning_of_day)
  end

  def clear_requests_today
    self.requests_today.destroy_all
  end

end
