FactoryBot.define do
  factory :request do
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    status { Request::STATUSES[:pending] }
    user { create(:user) }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }

    after :build do |request, e|
      request.request_details = FactoryBot.create_list(:request_detail, 1, request: request)
    end

    Request::STATUSES.values.each do |status_name|
      trait status_name.to_sym do
        status { status_name }
      end
    end
  end
end