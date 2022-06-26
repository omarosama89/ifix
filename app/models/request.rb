class Request < ApplicationRecord
  STATUSES = %w(pending accepted processing completed).index_by(&:to_sym)
  # Validations
  validates :status, presence: true, inclusion: { in: STATUSES.values }
  validates :price, :lat, :lng, presence: true

  # Relations
  belongs_to :user
  has_many :request_details

  accepts_nested_attributes_for :request_details
end
