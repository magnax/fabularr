# frozen_string_literal: true

%w[beach desert fields forest hills lakeside meadow mountains swamp tundra].each do |key|
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
      locationclass_id: 1,
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
  puts "Created location #{location.id}, type: #{lt.key}, position: #{position}"
end
