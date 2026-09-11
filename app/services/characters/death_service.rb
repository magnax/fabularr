# frozen_string_literal: true

module Characters
  class DeathService < ApplicationService
    def initialize(character_id)
      @character_id = character_id
    end

    def call
      character.update!(status: false, weight: Character::WEIGHT)

      drop_inventory!
    end

    private

    def drop_inventory!
      @character.inventory_objects.item.each do |item|
        location.location_objects.create!(subject: item.subject)
      end
      @character.inventory_objects.item.destroy_all

      @character.inventory_objects.resource.each do |item|
        LocationObjects::IncreaseAmountService.call(location, item.subject.key, item.amount)
      end
      @character.inventory_objects.resource.destroy_all
    end

    def location
      @location ||= @character.location
    end

    def character
      @character ||= Character.find_by(id: @character_id)
    end
  end
end
