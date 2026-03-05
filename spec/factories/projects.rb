# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    association :starting_character, factory: :character
    location
    project_type

    amount { 1 }
    unit { 'g' }

    trait :discover_resource do
      project_type { FactoryBot.create(:project_type, key: 'discover_resource') }
    end
  end
end
