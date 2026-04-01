# frozen_string_literal: true

FactoryBot.define do
  factory :location, aliases: [:spawn_location] do
    location_type
    location_class
    name { 'Fabular City' }
    parent_location_id { nil }
    coords { ActiveRecord::Point.new(x: 100, y: 100) }

    trait :building do
      location_class { FactoryBot.create(:location_class, :building) }
      location_type { FactoryBot.create(:location_type, key: 'wood_shack') }
    end
  end
end
