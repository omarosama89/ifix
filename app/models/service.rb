class Service < ApplicationRecord
  mount_uploader :icon, IconUploader

  has_many :provider_services
end
