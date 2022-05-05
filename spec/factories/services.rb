FactoryBot.define do
  factory :service do
    name { Faker::Name.name }
  end
end