FactoryBot.define do
  factory :invoice do
    customer_id { Faker::Number.digit }
    merchant_id { Faker::Number.digit }
    status { ['shipped', 'pending', 'cancelled'].sample }
  end
end