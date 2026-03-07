# frozen_string_literal: true

module Locations
  class CreateSpawnEvents < ApplicationService
    def initialize(location, character)
      @location = location
      @character = character
    end

    def call
      create_event('location_info', { location_type: location_type })
      create_event('people_info', { count: @location.characters.length - 1 })
      create_event('projects_info', { ongoing: ongoing_length, working: working_length })
    end

    private

    def create_event(key, params)
      @location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t("events.initial.#{key}", **params)
      )
    end

    def location_type
      I18n.t("locations.#{@location.location_type.key}")
    end

    def ongoing_length
      @location.projects.pending.length
    end

    def working_length
      @location.workers.pluck(:location_id).uniq.length
    end
  end
end
