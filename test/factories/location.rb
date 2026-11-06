# frozen_string_literal: true

FactoryBot.define do
  factory :location, aliases: [:spawn_location] do
    location_type
    location_class
    name { Faker::Name.name }
    parent_location_id { nil }
    coords { ActiveRecord::Point.new(x: 100, y: 100) }

    trait :building do
      location_class { FactoryBot.create(:location_class, :building) }
      location_type { FactoryBot.create(:location_type, key: 'wood_shack') }
    end

    trait :lighthouse do
      location_class { FactoryBot.create(:location_class, :building) }
      location_type { FactoryBot.create(:location_type, key: 'lighthouse') }
    end

    trait :vehicle do
      location_class { FactoryBot.create(:location_class, :vehicle) }
      location_type { FactoryBot.create(:location_type, key: 'small_wooden_cart') }
    end

    trait :ship do
      location_class { FactoryBot.create(:location_class, :ship) }
      location_type { FactoryBot.create(:location_type, key: 'sloop') }
    end
  end
end
