# frozen_string_literal: true

FactoryBot.define do
  factory :location_class do
    key { 'town' }
    moveable { false }

    trait :building do
      key { 'building' }
    end
  end
end
