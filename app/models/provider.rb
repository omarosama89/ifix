class Provider < ApplicationRecord
  # Validations
  validates :first_name, :last_name, presence: true
  validates :mobile_number, presence: true, uniqueness: true

  # Relations
  has_many :services, class_name: 'ProvideService'
  
  def full_name
    "#{first_name} #{last_name}"
  end
end
