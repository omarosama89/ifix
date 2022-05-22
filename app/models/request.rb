class Request < ApplicationRecord
  STATUSES = %w(pending accepted processing completed)

  # Validations
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :price, presence: true

  # Relations
  belongs_to :user
  belongs_to :provider_service
end
