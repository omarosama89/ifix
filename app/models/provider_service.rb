class ProviderService < ApplicationRecord
  # Validations
  validates :price, presence: true

  # Relations
  belongs_to :service
  belongs_to :provider
end
