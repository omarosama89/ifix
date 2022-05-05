class User < ApplicationRecord
  # Validations
  validates :first_name, :last_name, :token, :reset_token, presence: true
  validates :mobile_number, presence: true, uniqueness: true

  # Relations
  has_many :requests
end
