FactoryBot.define do
  factory :request_detail do
    provider_service { FactoryBot.create(:provider_service) }
  end
end
