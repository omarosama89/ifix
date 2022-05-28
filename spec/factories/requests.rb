FactoryBot.define do
  factory :request do
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    status { 'pending' }
    user { create(:user) }
    provider_service { create(:provider_service) }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }

    Request::STATUSES.each do |status_name|
      trait status_name.to_sym do
        status { status_name }
      end
    end
  end
end