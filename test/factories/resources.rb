# frozen_string_literal: true

FactoryBot.define do
  factory :resource do
    key { 'MyString' }

    trait :raw_food do
      resource_type_id { [FactoryBot.create(:resource_type, key: 'raw_food').id] }
    end
  end
end
