FactoryBot.define do
  factory :project do
    starting_character_id { 1 }
    location_id { 1 }
    amount { 1 }
    unit { "MyString" }
  end
end
