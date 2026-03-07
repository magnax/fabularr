# frozen_string_literal: true

# Create some initial locations:
# NOTE: names are mainly for administtative purposes as characters will see every location as "unknown location"

return unless Location.count < 10

User.create!(email: 'm@m.eu', password: 'fabular', password_confirmation: 'fabular')

%w[beach desert fields forest hills lakeside meadow mountains swamp tundra].each do |key|
  lt = LocationType.create!(key: key)
  Location.create({ name: Faker::Address.city, location_type_id: lt.id, locationclass_id: 1 })
end
