# frozen_string_literal: true

module Characters
  class CreateInitialEvents < ApplicationService
    def initialize(character)
      @character = character
      @location = @character.location
    end

    def call
      Locations::CreateSpawnEvents.call(@location, @character)

      @location.characters.each do |ch|
        next if ch == @character

        @location.events.create!(
          character_id: nil,
          receiver_character_id: ch.id,
          body: I18n.t('events.people.spawn_info', character_link: "<!--CHARID:#{@character.id}-->")
        )
      end
    end
  end
end
