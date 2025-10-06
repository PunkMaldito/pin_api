FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    stock { Faker::Number.between(from: 0, to: 100) }
    price { Faker::Commerce.price(range: 1.0..100.0) }
  end
end
