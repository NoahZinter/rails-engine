FactoryBot.define do
  factory :customer do
    first_name { Faker::Games::StreetFighter.character }
    last_name { Faker::Games::ElderScrolls.last_name }
  end
end