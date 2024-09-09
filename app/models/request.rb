class Request < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  scope :sos, -> { where(request_type: "sos") }
  scope :test, -> { where(request_type: "test") }
end
