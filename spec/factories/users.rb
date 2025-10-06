FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    role { "seller" }

    trait :seller do
      role { "seller" }
    end

    trait :builder do
      role { "builder" }
    end

    trait :admin do
      role { "admin" }
    end
  end
end
