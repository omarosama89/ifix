class ProviderService < ApplicationRecord
  # Delegation
  delegate :name, to: :service

  # Validations
  validates :price, presence: true

  # Relations
  belongs_to :service
  belongs_to :provider
end
