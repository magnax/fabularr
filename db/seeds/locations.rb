# frozen_string_literal: true

%w[beach desert fields forest hills lakeside meadow mountains swamp tundra].each do |key|
  lt = LocationType.create!(key: key)
  Location.create({ name: Faker::Address.city, location_type_id: lt.id, locationclass_id: 1 })
end
