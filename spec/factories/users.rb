FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }
    mobile_number { Faker::PhoneNumber.subscriber_number(length: 11) }
    verified { true }
    token { SecureRandom.hex(16) }
    reset_token { SecureRandom.hex(16) }

    trait :unverified do
      verified { false }
    end
  end
end