# frozen_string_literal: true

module Seeds
  class Locations < ApplicationService
    def call
      create_location_classes!
      create_buildings_and_vehicles!

      Definitions::LocationTypes::CONFIG_TOWNS.each do |key|
        create_location!(key)
      end

      add_sample_characters!
      add_sample_items_and_resources_to_locations!
    end

    private

    def create_location_classes!
      LocationClass.where(key: 'town').first_or_create
      LocationClass.where(key: 'animal').first_or_create(moveable: true)
      LocationClass.where(key: 'building').first_or_create(moveable: false)
      LocationClass.where(key: 'vehicle').first_or_create(moveable: true)
    end

    def create_buildings_and_vehicles!
      Definitions::LocationTypes::CONFIG_BUILDINGS.each_key do |key|
        LocationType.create!(key: key)
      end

      Definitions::LocationTypes::CONFIG_VEHICLES.each_key do |key|
        LocationType.create!(key: key)
      end
    end

    def create_location!(key)
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
      location = ::Locations::CreateService.call(
        position, { name: Faker::Address.city }
      )
      Log.say "Created location #{location.id}, type: #{lt.key}, position: #{position}"
    end

    def add_sample_characters!
      active_locations = Location.all.sample(2)

      User.all.find_each do |user|
        10.times do
          location = active_locations.sample
          character = Character.create!(
            user: user,
            name: Faker::FunnyName.name,
            location: location,
            spawn_location: location,
            gender: %w[K M].sample
          )
          Characters::AssignSkillsService.call(character)
        end
      end
    end

    def add_sample_items_and_resources_to_locations!
      stone = Resource.find_by(key: 'stone')
      wood = Resource.find_by(key: 'wood')
      knife = ItemType.find_by(key: 'stone_knife')
      Location.find_each do |loc|
        loc.location_objects.create(subject: stone, amount: 500)
        loc.location_objects.create(subject: wood, amount: 500)
        i = Item.create(item_type: knife)
        loc.location_objects.create(subject: i)
      end
      Log.say "Added resources & items to locations (#{LocationObject.count} total)"
    end
  end
end
