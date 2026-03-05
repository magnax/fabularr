# frozen_string_literal: true

module Characters
  class CreateInitialEvents < ApplicationService
    def initialize(character)
      @character = character
    end

    def call
      location = @character.location
      location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.initial.location_info')
      )
      location.events.create!(
        character_id: nil,
        receiver_character_id: @character.id,
        body: I18n.t('events.initial.people_info', count: location.characters.length - 1)
      )
      location.characters.each do |ch|
        next if ch == @character

        location.events.create!(
          character_id: nil,
          receiver_character_id: ch.id,
          body: I18n.t('events.people.spawn_info', character_link: "<!--CHARID:#{@character.id}-->")
        )
      end
    end

    private
  end
end
