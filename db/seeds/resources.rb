# frozen_string_literal: true

r_food = ResourceType.where(key: 'food').first_or_create
r_fuel = ResourceType.where(key: 'fuel').first_or_create
r_material = ResourceType.where(key: 'material').first_or_create
r_medicine = ResourceType.where(key: 'medicine').first_or_create
r_raw_food = ResourceType.where(key: 'raw_food').first_or_create

resources = [
  {
    key: 'strawberries', bs: 57,
    types: [r_food.id]
  },
  {
    key: 'mushrooms', bs: 72,
    types: [r_food.id]
  },
  {
    key: 'nuts', bs: 21,
    types: [r_food.id]
  },
  {
    key: 'coal', bs: 43,
    types: [r_fuel.id]
  },
  {
    key: 'wood', bs: 45,
    types: [r_fuel.id, r_material.id]
  },
  {
    key: 'sand', bs: 35,
    types: [r_material.id]
  },
  {
    key: 'seaweeds', bs: 90,
    types: [r_raw_food.id]
  },
  {
    key: 'salmon', bs: 43,
    types: [r_raw_food.id]
  },
  {
    key: 'beeswax', bs: 288,
    types: [r_medicine.id]
  },
  {
    key: 'stone', bs: 450,
    types: [r_material.id]
  }
]

resources.each do |res|
  Resource.create!(key: res[:key], unit: 'grams', base_speed_per_unit: res[:bs], resource_type_id: res[:types])
end

puts "ResourceTypes (#{ResourceType.count}), Resources: #{Resource.pluck(:key).join(', ')} loaded"
