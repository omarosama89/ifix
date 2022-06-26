class RequestDetail < ApplicationRecord
  # Relations
  belongs_to :request
  belongs_to :provider_service
end
