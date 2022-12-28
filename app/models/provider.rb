class Provider < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable, authentication_keys: [:mobile_number]
  include DeviseTokenAuth::Concerns::User

  # Validations
  validates :first_name, :last_name, presence: true
  validates :mobile_number, presence: true, uniqueness: true

  # Relations
  has_many :provider_services
  accepts_nested_attributes_for :provider_services

  def full_name
    "#{first_name} #{last_name}"
  end

  def provider
    "mobile_number"
  end
end
