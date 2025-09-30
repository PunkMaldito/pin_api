FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    stock { Faker::Number.digit }
    price { Faker::Number.decimal(r_digits: 1) }
  end
end
