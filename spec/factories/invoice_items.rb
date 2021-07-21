FactoryBot.define do
  factory :invoice_item do
    association :item
    association :invoice
    quantity { Faker::Number.within(range: 2..20) }
    unit_price { Faker::Commerce.price }
  end
end
