# frozen_string_literal: true

module Characters
  class DeathService < ApplicationService
    def initialize(character_id)
      @character_id = character_id
    end

    def call
      character.update!(status: false, weight: Character::WEIGHT)

      Workers::EndService.call(character)
      drop_inventory!
      create_events!
    end

    private

    def drop_inventory!
      character.inventory_objects.item.each do |item|
        location.location_objects.create!(subject: item.subject)
      end
      character.inventory_objects.item.destroy_all

      character.inventory_objects.resource.each do |item|
        LocationObjects::IncreaseAmountService.call(location, item.subject.key, item.amount)
      end
      character.inventory_objects.resource.destroy_all
    end

    def create_events!
      location.visible_characters.each do |char|
        body = I18n.t('events.death', character_link: character.char_id)

        Events::CreateAndBroadcastService.call(char, body)
      end
    end

    def location
      @location ||= character.location
    end

    def character
      @character ||= Character.find_by(id: @character_id)
    end
  end
end
