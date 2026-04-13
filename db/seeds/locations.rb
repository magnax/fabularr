# frozen_string_literal: true

town_class = LocationClass.where(key: 'town').first_or_create
LocationClass.where(key: 'animal').first_or_create(moveable: true)
LocationClass.where(key: 'building').first_or_create(moveable: false)
LocationClass.where(key: 'vehicle').first_or_create(moveable: true)

Definitions::LocationTypes::CONFIG_BUILDINGS.each_key do |key|
  LocationType.create!(key: key)
end

Definitions::LocationTypes::CONFIG_TOWNS.each do |key|
  location_type = LocationType.create!(key: key)
  found = false
  until found
    position = ActiveRecord::Point.new(x: rand(1000), y: rand(1000))
    begin
      lt = Maps.location_type(position.x, position.y)
      found = lt.is_a?(LocationType) && lt == location_type
    rescue Maps::InvalidMapColorError
      nil
    end
  end
  location = Location.create(
    {
      name: Faker::Address.city,
      location_type_id: lt.id,
      location_class_id: town_class.id,
      coords: position
    }
  )
  Character.create!(
    user: User.first,
    name: Faker::FunnyName.name,
    location: location,
    spawn_location: location,
    gender: %w[K M].sample
  )
  Log.say "Created location #{location.id}, type: #{lt.key}, position: #{position}"
end
