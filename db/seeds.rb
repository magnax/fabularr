# frozen_string_literal: true

# Create some initial locations:
# NOTE: names are mainly for administtative purposes as characters will see every location as "unknown location"

return unless Location.count < 10

User.create!(email: 'm@m.eu', password: 'fabular', password_confirmation: 'fabular')

%w[beach desert fields forest hills lakeside meadow mountains swamp tundra].each do |key|
  lt = LocationType.create!(key: key)
  Location.create({ name: Faker::Address.city, location_type_id: lt.id, locationclass_id: 1 })
end

r_food = ResourceType.where(key: 'food').first_or_create
r_fuel = ResourceType.where(key: 'fuel').first_or_create
r_material = ResourceType.where(key: 'material').first_or_create
r_medicine = ResourceType.where(key: 'medicine').first_or_create
r_raw_food = ResourceType.where(key: 'raw_food').first_or_create

resources = [
  { key: 'strawberries', unit: 'grams', types: [r_food.id] },
  { key: 'mushrooms', unit: 'grams', types: [r_food.id] },
  { key: 'nuts', unit: 'grams', types: [r_food.id] },
  { key: 'coal', unit: 'kilograms', types: [r_fuel.id] },
  { key: 'wood', unit: 'kilograms', types: [r_fuel.id, r_material.id] },
  { key: 'sand', unit: 'kilograms', types: [r_material.id] },
  { key: 'seaweeds', unit: 'grams', types: [r_raw_food.id] },
  { key: 'salmon', unit: 'grams', types: [r_raw_food.id] },
  { key: 'beeswax', unit: 'grams', types: [r_medicine.id] }
]

resources.each { |res| Resource.create!(key: res[:key], unit: res[:unit], resource_type_id: res[:types]) }
