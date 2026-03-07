# frozen_string_literal: true

module Locations
  class CreateSpawnEvents < ApplicationService
    def initialize(location, character)
      @location = location
      @character = character
    end

    def call
      @location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.initial.location_info', location_type: I18n.t("locations.#{@location.location_type.key}"))
      )
      @location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.initial.people_info', count: @location.characters.length - 1)
      )
    end
  end
end
