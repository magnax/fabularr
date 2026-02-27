# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    association :starting_character, factory: :character
    location
    project_type

    amount { 1 }
    unit { 'g' }
  end
end
