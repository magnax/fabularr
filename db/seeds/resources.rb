# frozen_string_literal: true

r_food = ResourceType.where(key: 'food').first_or_create
r_fuel = ResourceType.where(key: 'fuel').first_or_create
r_material = ResourceType.where(key: 'material').first_or_create
r_medicine = ResourceType.where(key: 'medicine').first_or_create
r_raw_food = ResourceType.where(key: 'raw_food').first_or_create

resources = [
  {
    key: 'strawberries', unit: 'grams', bs: 57,
    types: [r_food.id]
  },
  {
    key: 'mushrooms', unit: 'grams', bs: 72,
    types: [r_food.id]
  },
  {
    key: 'nuts', unit: 'grams', bs: 21,
    types: [r_food.id]
  },
  {
    key: 'coal', unit: 'kilograms', bs: 4320,
    types: [r_fuel.id]
  },
  {
    key: 'wood', unit: 'kilograms', bs: 4500,
    types: [r_fuel.id, r_material.id]
  },
  {
    key: 'sand', unit: 'kilograms', bs: 3500,
    types: [r_material.id]
  },
  {
    key: 'seaweeds', unit: 'grams', bs: 90,
    types: [r_raw_food.id]
  },
  {
    key: 'salmon', unit: 'grams', bs: 43,
    types: [r_raw_food.id]
  },
  {
    key: 'beeswax', unit: 'grams', bs: 288,
    types: [r_medicine.id]
  },
  {
    key: 'stone', unit: 'grams', bs: 450,
    types: [r_material.id]
  }
]

resources.each do |res|
  Resource.create!(key: res[:key], unit: res[:unit], base_speed_per_unit: res[:bs], resource_type_id: res[:types])
end

puts "ResourceTypes (#{ResourceType.count}), Resources: #{Resource.pluck(:key).join(', ')} loaded"
