class Provider < ApplicationRecord
  # Validations
  validates :first_name, :last_name, presence: true
  validates :mobile_number, presence: true, uniqueness: true

  # Relations
  has_many :provider_services
  accepts_nested_attributes_for :provider_services

  def full_name
    "#{first_name} #{last_name}"
  end
end
