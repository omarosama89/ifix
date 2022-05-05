FactoryBot.define do
  factory :provider_service do
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    service {  create(:service)  }
    provider {  create(:provider)  }
  end
end