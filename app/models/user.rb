class User < ApplicationRecord
  # Validations
  validates :first_name, :last_name, presence: true
  validates :mobile_number, presence: true, uniqueness: true

  # Relations
  has_many :requests

  def full_name
    "#{first_name} #{last_name}"
  end
end
