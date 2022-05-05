FactoryBot.define do
  factory :request do
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    status { 'pending' }
    user { create(:user) }
    provider_service { create(:provider_service) }
  end
end