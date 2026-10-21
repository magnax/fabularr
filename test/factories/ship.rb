# frozen_string_literal: true

FactoryBot.define do
  factory :ship do
    location_class { FactoryBot.create(:location_class, :ship) }
    location_type { FactoryBot.create(:location_type, key: 'sloop') }
    name { 'Vinterriket' }
    parent_location_id { nil }
    coords { ActiveRecord::Point.new(x: 100, y: 100) }
  end
end
